{lib, ...}: let
  machines = ["nixos" "serverless"];
  desktopManagers = ["hyprland" "plasma"];
in {
  options.hosts.host = lib.mkOption {
    type = lib.types.enum machines;
    default = "serverless";
    description = "set host machine for build";
  };
  options.desktopManagers = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "setting this value to false mean tty mode";
    };
    mode = lib.mkOption {
      type = lib.types.enum desktopManagers;
      description = "options like hyprland and plasma";
      example = "hyprland";
    };
  };
  options.fingerprintSupported = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "add support for fingerprint";
  };
}
