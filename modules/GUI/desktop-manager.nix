{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.desktopManagers.enable && config.desktopManagers.mode == "plasma") {
    services = {
      #Enable the KDE Plasma Desktop Environment.
      # wayland with plasma 6
      xserver = {
        enable = true;
        xkb.layout = "fr,ara";
        xkb.variant = "azerty";
        videoDrivers = ["amdgpu"];
      };
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
      };
      desktopManager.plasma6.enable = true;
    };
  };
}
