{
  config,
  lib,
  ...
}: let
  machines = ["nixos" "serverless"];
  roles = ["workstation" "server"];
  desktopManagers = ["hyprland" "plasma"];
in {
  options.nyx = {
    host = {
      name = lib.mkOption {
        type = lib.types.enum machines;
        default = "serverless";
        description = "Host name managed by this flake.";
      };

      role = lib.mkOption {
        type = lib.types.enum roles;
        default = "server";
        description = "High-level machine role used by local modules.";
      };
    };

    desktop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this host runs a graphical desktop.";
      };

      session = lib.mkOption {
        type = lib.types.enum desktopManagers;
        default = "hyprland";
        description = "Desktop session to configure when the desktop is enabled.";
      };
    };

    hardware = {
      fingerprint = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this host has supported fingerprint hardware.";
      };
    };

    services = {
      web.enable = lib.mkEnableOption "local Apache/PHP web hosting";
      mysql.enable = lib.mkEnableOption "MariaDB service";
      steam.enable = lib.mkEnableOption "Steam and gaming runtime support";
      syncthing.enable = lib.mkEnableOption "Syncthing personal file sync";

      virtualization.host = lib.mkEnableOption "local libvirt VM host tooling";
    };
  };

  options.hosts.host = lib.mkOption {
    type = lib.types.enum machines;
    default = "serverless";
    description = "Compatibility alias for nyx.host.name.";
  };

  options.desktopManagers = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Compatibility alias for nyx.desktop.enable.";
    };
    mode = lib.mkOption {
      type = lib.types.enum desktopManagers;
      default = "hyprland";
      description = "Compatibility alias for nyx.desktop.session.";
      example = "hyprland";
    };
  };

  options.fingerprintSupported = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Compatibility alias for nyx.hardware.fingerprint.";
  };

  config = {
    hosts.host = lib.mkDefault config.nyx.host.name;
    desktopManagers = {
      enable = lib.mkDefault config.nyx.desktop.enable;
      mode = lib.mkDefault config.nyx.desktop.session;
    };
    fingerprintSupported = lib.mkDefault config.nyx.hardware.fingerprint;
  };
}
