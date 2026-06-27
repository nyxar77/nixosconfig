{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.nyx.services.steam.enable {
  programs.steam = {
    enable = true;

    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
        OBS_VKCAPTURE = true;
        RADV_TEX_ANISO = 16;
      };
    };
  };
}
