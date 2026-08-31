{
  config,
  lib,
  ...
}: let
  desktopEnabled = config.nyx.desktop.enable;
  isPlasma = desktopEnabled && config.nyx.desktop.session == "plasma";
in
  lib.mkIf isPlasma {
    services = {
      xserver = {
        enable = true;
        xkb.layout = "fr,ara";
        xkb.variant = "azerty";
        videoDrivers = ["amdgpu"];
      };

      desktopManager.plasma6.enable = true;
    };
  }
