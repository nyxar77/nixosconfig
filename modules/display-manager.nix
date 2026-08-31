{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.displayManager;
  sddm-astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    themeConfig = {
      HeaderText = "Welcome back, nyxar";
      DateFormat = "dddd, MMMM d";
      HourFormat = "HH:mm";
      HeaderTextColor = "#d5c4a1";
      DateTextColor = "#d5c4a1";
      TimeTextColor = "#ebdbb2";
      FormBackgroundColor = "#1d2021";
      Background = "Backgrounds/pixel_sakura.gif";
    };
  };
in {
  config = lib.mkMerge [
    (lib.mkIf (cfg == "ly") {
      services.displayManager.ly = {
        enable = true;
        settings = {
          load = true;
          save = true;
          bg = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/nyxar77/homeconfig/refs/heads/master/assets/Wallpapers/purple-pixel-art-wallpapers.jpg";
            hash = "sha256-9LFJ6XDeeOkz1XWGXyc7miobNKe+0aK6wW15Ur+O4Us=";
          };
        };
      };
    })
    (lib.mkIf (cfg == "sddm") {
      services.displayManager.sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "sddm-astronaut-theme";
        extraPackages = with pkgs.kdePackages; [
          qtmultimedia
          qtsvg
          qtvirtualkeyboard
        ];
      };
      environment.systemPackages = [sddm-astronaut];
    })
  ];
}
