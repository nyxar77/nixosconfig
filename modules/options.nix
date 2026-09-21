{
  config,
  hostNames,
  lib,
  ...
}:
let
  machines = builtins.attrValues hostNames;
  desktopSessions = ["hyprland" "plasma"];
  displayManagers = ["none" "ly" "sddm"];
in {
  options.nyx = {
    host = {
      name = lib.mkOption {
        type = lib.types.enum machines;
        default = "serverless";
        description = "Host name managed by this flake.";
      };
    };

    desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this host runs a graphical desktop.";
      };

      session = lib.mkOption {
        type = lib.types.enum desktopSessions;
        default = "hyprland";
        description = "Desktop session to configure when the desktop is enabled.";
      };
    };

    displayManager = lib.mkOption {
      type = lib.types.enum displayManagers;
      default = "none";
      description = "Login manager to run independently of the desktop session.";
    };

    hardware = {
      fingerprint = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this host has supported fingerprint hardware.";
      };
    };

    network.hosts.serverless.ipv4 = lib.mkOption {
      type = lib.types.str;
      default = "192.168.1.50";
      description = "Static LAN IPv4 address of the serverless host.";
    };

    network.hosts.serverless.lanInterface = lib.mkOption {
      type = lib.types.str;
      default = "enp1s0";
      description = "LAN interface of the serverless host.";
    };

    network = {
      tailscale.enable = lib.mkEnableOption "Tailscale private networking";
      wireguard.enable = lib.mkEnableOption "the private WireGuard network";
    };

    services = {
      attic = {
        enable = lib.mkEnableOption "the local Attic binary cache client";
        server = lib.mkEnableOption "hosting the local Attic binary cache";
      };

      immich.enable = lib.mkEnableOption "the Immich photo and video library";
      web.enable = lib.mkEnableOption "local Apache/PHP web hosting";
      mysql.enable = lib.mkEnableOption "MariaDB service";
      steam.enable = lib.mkEnableOption "Steam and gaming runtime support";
      syncthing.enable = lib.mkEnableOption "Syncthing personal file sync";

      virtualization.host = lib.mkEnableOption "local libvirt VM host tooling";
    };
  };

  config.networking.hostName = config.nyx.host.name;
}
