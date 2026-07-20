{
  lib,
  ...
}:
let
  machines = ["nixos" "serverless"];
  roles = ["workstation" "server"];
  desktopSessions = ["hyprland" "plasma"];
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
        type = lib.types.enum desktopSessions;
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

}
