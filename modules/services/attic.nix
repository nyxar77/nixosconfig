{
  config,
  hostNames,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nyx.services.attic;

  cacheName = "system";
  serverAddress = config.nyx.network.hosts.serverless.ipv4;
  serverInterface = config.nyx.network.hosts.serverless.lanInterface;
  serverPort = 20080;
  serverEndpoint = "http://${serverAddress}:${toString serverPort}/";
  tokenFile = config.sops.secrets.attic-client-token.path;
  nixCacheConfig = "/var/lib/attic-client/nix.conf";
  atticEnvironmentFile = config.sops.templates."atticd.env".path;

  atticClientConfig = pkgs.writeTextDir "attic/config.toml" ''
    default-server = "lan"

    [servers.lan]
    endpoint = "${serverEndpoint}"
    token-file = "${tokenFile}"
  '';

  atticServerSettings = {
    listen = "0.0.0.0:${toString serverPort}";
    allowed-hosts = [
      "${serverAddress}:${toString serverPort}"
      "${hostNames.server}:${toString serverPort}"
      "127.0.0.1:${toString serverPort}"
      "localhost:${toString serverPort}"
    ];
    api-endpoint = serverEndpoint;

    database.url = "sqlite:///var/lib/atticd/server.db?mode=rwc";
    storage = {
      type = "local";
      path = "/srv/atticd/storage";
    };
    chunking = {
      nar-size-threshold = 65536;
      min-size = 16384;
      avg-size = 65536;
      max-size = 262144;
    };
    compression.type = "zstd";
    garbage-collection = {
      interval = "1 day";
      default-retention-period = "1 year";
    };
  };

  atticServerConfig = (pkgs.formats.toml { }).generate "attic-server.toml" atticServerSettings;

  pushCurrentSystem = pkgs.writeShellScriptBin "attic-push-system" ''
    if [ ! -r ${tokenFile} ]; then
      echo "Missing Attic upload token at ${tokenFile}." >&2
      exit 1
    fi

    export XDG_CONFIG_HOME=${atticClientConfig}
    exec ${lib.getExe pkgs.attic-client} push ${cacheName} /run/current-system
  '';

  configureNixCache = pkgs.writeShellScriptBin "attic-configure-cache" ''
    exec ${lib.getExe' pkgs.systemd "systemctl"} start attic-cache-config.service
  '';
in
lib.mkIf cfg.enable (lib.mkMerge [
  {
    sops.secrets.attic-client-token = {
      sopsFile = ../../secrets/attic.yaml;
      mode = "0400";
    };

    environment.systemPackages = [
      pkgs.attic-client
      configureNixCache
      pushCurrentSystem
    ];

    # The cache signing key is generated when Attic creates the cache. A
    # manually started service writes this optional include after discovering it.
    nix.extraOptions = ''
      !include ${nixCacheConfig}
    '';
    nix.settings = {
      connect-timeout = 2;
      fallback = true;
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/attic-client 0755 root root -"
    ];

    systemd.services.attic-cache-config = {
      description = "Discover the LAN Attic cache signing key";
      wants = ["network-online.target"];
      after = ["network-online.target"] ++ lib.optionals cfg.server ["attic-init.service"];

      path = [
        pkgs.coreutils
        pkgs.curl
        pkgs.jq
        pkgs.systemd
      ];

      serviceConfig.Type = "oneshot";
      script = ''
        if ! response="$(curl --fail --silent --show-error --connect-timeout 2 \
          ${serverEndpoint}_api/v1/cache-config/${cacheName})"; then
          echo "Attic is unavailable; the Nix cache configuration was not changed." >&2
          exit 1
        fi

        public_key="$(printf '%s' "$response" | jq --exit-status --raw-output '.public_key')"
        temporary="$(mktemp /var/lib/attic-client/nix.conf.XXXXXX)"
        printf 'extra-substituters = ${serverEndpoint}${cacheName}\nextra-trusted-public-keys = %s\n' \
          "$public_key" > "$temporary"
        chmod 0444 "$temporary"

        if cmp --silent "$temporary" ${nixCacheConfig} 2>/dev/null; then
          rm "$temporary"
          exit 0
        fi

        mv "$temporary" ${nixCacheConfig}
        systemctl try-restart nix-daemon.service
      '';
    };

  }

  (lib.mkIf cfg.server {
    assertions = [
      {
        assertion = config.nyx.host.name == hostNames.server;
        message = "The Attic server is expected to run on the ${hostNames.server} host.";
      }
    ];

    services.atticd = {
      enable = true;
      environmentFile = atticEnvironmentFile;
      settings = atticServerSettings;
    };

    users = {
      groups.atticd = { };
      users.atticd = {
        isSystemUser = true;
        group = "atticd";
      };
    };

    systemd = {
      services.atticd.serviceConfig.DynamicUser = lib.mkForce false;
      tmpfiles.rules = [
        "d /srv/atticd 0700 atticd atticd -"
        "d /srv/atticd/storage 0700 atticd atticd -"
      ];
    };

    sops = {
      secrets.attic-server-token-rs256-secret-base64 = {
        sopsFile = ../../secrets/attic.yaml;
        mode = "0400";
      };

      templates."atticd.env" = {
        mode = "0400";
        content = ''
          ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=${config.sops.placeholder."attic-server-token-rs256-secret-base64"}
        '';
      };
    };

    networking.firewall.interfaces.${serverInterface}.allowedTCPPorts = [serverPort];

    systemd.services.attic-init = {
      description = "Create the public LAN Attic cache";
      wantedBy = ["multi-user.target"];
      requires = ["atticd.service"];
      after = ["atticd.service"];

      path = [
        pkgs.coreutils
        pkgs.curl
      ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        RuntimeDirectory = "attic-init";
        RuntimeDirectoryMode = "0700";
        UMask = "0077";
      };

      script = ''
        set -a
        . ${atticEnvironmentFile}
        set +a

        for attempt in $(seq 1 30); do
          if curl --fail --silent http://127.0.0.1:${toString serverPort}/ >/dev/null; then
            break
          fi
          if [ "$attempt" -eq 30 ]; then
            echo "Attic did not become ready in time." >&2
            exit 1
          fi
          sleep 1
        done

        if ! curl --fail --silent ${serverEndpoint}_api/v1/cache-config/${cacheName} >/dev/null; then
          admin_token="$(${pkgs.attic-server}/bin/atticadm -f ${atticServerConfig} \
            make-token --sub bootstrap --validity 5m \
            --create-cache ${cacheName})"

          install -d -m 0700 /run/attic-init/attic
          printf '%s\n' "$admin_token" > /run/attic-init/admin-token
          printf '%s\n' \
            'default-server = "lan"' \
            '[servers.lan]' \
            'endpoint = "${serverEndpoint}"' \
            'token-file = "/run/attic-init/admin-token"' \
            > /run/attic-init/attic/config.toml

          XDG_CONFIG_HOME=/run/attic-init \
            ${lib.getExe pkgs.attic-client} cache create ${cacheName} \
              --public --priority 10
        fi
      '';
    };
  })
])
