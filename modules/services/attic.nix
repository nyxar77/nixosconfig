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

  atticPushPrelude = ''
    set -euo pipefail
  '';

  atticPushEnvironment = ''
    if [ ! -r ${tokenFile} ]; then
      echo "Missing Attic upload token at ${tokenFile}." >&2
      echo "Run this command with sudo." >&2
      exit 1
    fi

    export XDG_CONFIG_HOME=${atticClientConfig}
  '';

  parseAtticPushArguments = ''
    print_attic_push_usage() {
      local user_argument=""
      if [ "$1" = true ]; then
        user_argument=" [USER]"
      fi

      cat <<EOF
    Usage: $0 [OPTIONS]$user_argument

    Options:
      -j, --jobs JOBS                 Maximum parallel uploads (default: 1)
          --ignore-upstream-cache-filter
                                      Upload paths even when available upstream
      -h, --help                      Show this help
    EOF
    }

    parse_attic_push_arguments() {
      local accepts_user="$1"
      shift

      local jobs=1
      local -a extra_options=()
      attic_push_user_arguments=()

      while [ "$#" -gt 0 ]; do
        case "$1" in
          -j | --jobs)
            if [ "$#" -lt 2 ]; then
              echo "Missing value for $1." >&2
              print_attic_push_usage "$accepts_user" >&2
              return 64
            fi
            jobs="$2"
            shift 2
            ;;
          --jobs=*)
            jobs="''${1#*=}"
            shift
            ;;
          --ignore-upstream-cache-filter)
            extra_options+=("$1")
            shift
            ;;
          -h | --help)
            print_attic_push_usage "$accepts_user"
            exit 0
            ;;
          --)
            shift
            break
            ;;
          -*)
            echo "Unknown option: $1" >&2
            print_attic_push_usage "$accepts_user" >&2
            return 64
            ;;
          *)
            break
            ;;
        esac
      done

      case "$jobs" in
        "" | *[!0-9]* | 0)
          echo "JOBS must be a positive integer, got: $jobs" >&2
          return 64
          ;;
      esac

      if [ "$accepts_user" = true ]; then
        if [ "$#" -gt 1 ]; then
          echo "Only one Home Manager user may be specified." >&2
          print_attic_push_usage "$accepts_user" >&2
          return 64
        fi
        attic_push_user_arguments=("$@")
      elif [ "$#" -ne 0 ]; then
        echo "This command does not accept a user argument." >&2
        print_attic_push_usage "$accepts_user" >&2
        return 64
      fi

      attic_push_options=(--jobs "$jobs" "''${extra_options[@]}")
    }
  '';

  resolveHomeManagerProfile = ''
    resolve_home_manager_profile() {
      if [ "$#" -gt 1 ]; then
        echo "Usage: $0 [USER]" >&2
        return 64
      fi

      local user_name
      if [ "$#" -eq 1 ]; then
        user_name="$1"
      elif [ -n "''${SUDO_USER:-}" ] && [ "''${SUDO_USER}" != "root" ]; then
        user_name="''${SUDO_USER}"
      else
        echo "Cannot determine the Home Manager user." >&2
        echo "Run through sudo from that user, or pass the user name explicitly." >&2
        return 64
      fi

      case "$user_name" in
        "" | root | *[!a-zA-Z0-9._-]*)
          echo "Refusing invalid Home Manager user: $user_name" >&2
          return 64
          ;;
      esac

      local passwd_entry uid home_directory profile resolved
      if ! passwd_entry="$(${lib.getExe pkgs.getent} passwd "$user_name")"; then
        echo "No local account exists for Home Manager user: $user_name" >&2
        return 1
      fi

      IFS=: read -r _ _ uid _ _ home_directory _ <<< "$passwd_entry"
      case "$uid" in
        "" | 0 | *[!0-9]*)
          echo "Refusing invalid account details for Home Manager user: $user_name" >&2
          return 1
          ;;
      esac
      case "$home_directory" in
        /*) ;;
        *)
          echo "Refusing invalid home directory for Home Manager user: $user_name" >&2
          return 1
          ;;
      esac

      profile="$home_directory/.local/state/nix/profiles/home-manager"
      if [ ! -e "$profile" ]; then
        echo "No active standalone Home Manager profile exists at $profile" >&2
        return 1
      fi

      if ! resolved="$(${lib.getExe' pkgs.coreutils "readlink"} -e -- "$profile")"; then
        echo "Cannot resolve Home Manager profile: $profile" >&2
        return 1
      fi

      case "$resolved" in
        /nix/store/*-home-manager-generation)
          printf '%s\n' "$resolved"
          ;;
        *)
          echo "Refusing unexpected Home Manager profile target: $resolved" >&2
          return 1
          ;;
      esac
    }
  '';

  pushCurrentSystem = pkgs.writeShellScriptBin "attic-push-system" ''
    ${atticPushPrelude}
    ${parseAtticPushArguments}

    parse_attic_push_arguments false "$@"
    ${atticPushEnvironment}
    exec ${lib.getExe pkgs.attic-client} push "''${attic_push_options[@]}" \
      ${cacheName} /run/current-system
  '';

  pushCurrentHome = pkgs.writeShellScriptBin "attic-push-home" ''
    ${atticPushPrelude}
    ${parseAtticPushArguments}
    ${resolveHomeManagerProfile}

    parse_attic_push_arguments true "$@"
    ${atticPushEnvironment}
    home_manager_profile="$(resolve_home_manager_profile "''${attic_push_user_arguments[@]}")"
    exec ${lib.getExe pkgs.attic-client} push "''${attic_push_options[@]}" \
      ${cacheName} "$home_manager_profile"
  '';

  pushCurrentSystemAndHome = pkgs.writeShellScriptBin "attic-push-all" ''
    ${atticPushPrelude}
    ${parseAtticPushArguments}
    ${resolveHomeManagerProfile}

    parse_attic_push_arguments true "$@"
    ${atticPushEnvironment}
    home_manager_profile="$(resolve_home_manager_profile "''${attic_push_user_arguments[@]}")"
    exec ${lib.getExe pkgs.attic-client} push "''${attic_push_options[@]}" ${cacheName} \
      /run/current-system "$home_manager_profile"
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
      pushCurrentHome
      pushCurrentSystemAndHome
      pushCurrentSystem
    ];

    # The cache signing key is generated when Attic creates the cache. A
    # manually started service writes this optional include after discovering it.
    nix.extraOptions = ''
      !include ${nixCacheConfig}
    '';
    systemd.tmpfiles.rules = [
      "d /var/lib/attic-client 0755 root root -"
    ];

    systemd.timers.attic-cache-config = {
      description = "Periodically discover the LAN Attic cache";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "30s";
        OnUnitActiveSec = "1min";
        Unit = "attic-cache-config.service";
      };
    };

    systemd.services.attic-cache-config = {
      description = "Reconcile the LAN Attic cache configuration";
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
        cache_available=false
        if response="$(curl --fail --silent --show-error --connect-timeout 2 --max-time 5 \
          ${serverEndpoint}_api/v1/cache-config/${cacheName})"; then
          if public_key="$(printf '%s' "$response" | jq --exit-status --raw-output \
            '.public_key | select(type == "string" and length > 0)')"; then
            cache_available=true
          fi
        fi

        if ! "$cache_available"; then
          if [ -e ${nixCacheConfig} ]; then
            rm -f ${nixCacheConfig}
            systemctl try-restart nix-daemon.service
            echo "Attic is unavailable; removed it from the Nix substituters."
          fi
          exit 0
        fi

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
