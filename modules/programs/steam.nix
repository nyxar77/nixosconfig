{
  lib,
  pkgs,
  hostRole,
  ...
}:
lib.mkIf (hostRole == "nixos") {
  programs = {
    thunderbird.enable = true;
    nix-ld.enable = true;
    neovim.enable = true;
    zsh.enable = true;
  };
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
