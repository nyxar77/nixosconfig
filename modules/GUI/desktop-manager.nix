{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkMerge [
  (lib.mkIf
    (config.desktopManagers.enable && config.desktopManagers.mode == "plasma")
    {
      services = {
        # Enable the KDE Plasma Desktop Environment.
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
    })
  (lib.mkIf
    (config.desktopManagers.enable && config.desktopManagers.mode == "hyprland")
    {
      environment.systemPackages = with pkgs; [
        greetd.greetd
        gtk3
        gtk4
        # ----aesthetics----
        pipes
        tty-clock
        cava
        libnotify # dependency for dunst
        rofi-wayland
        rofi-emoji
        swww # change wallpaper
        mpd-small # ncmpcpp depend on it
        ncmpcpp
        wlogout
        flavours # color picker from wallpaper
        rofi-bluetooth
        hyprcursor
        cliphist # clipboard manager
        slurp # select a region in a Wc
        grim # grab images from a wayland compositor
        networkmanager_dmenu
        pinentry-qt

        libgtop
        upower
        matugen
        hyprpicker
        hyprshot
        flameshot # screenshots

        gtk-layer-shell
        libdbusmenu-gtk3

        #--- hyprpanel dependencies ---
        /*
        aylurs-gtk-shell-git
        wireplumber
        libgtop
        bluez
        */
      ];

      # enabling tilting window manager hyperland

      /*
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };
      hardware.graphics.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };

      services = {
        #Dbus for power management
        upower.enable = true;
        # login manager daemon
        greetd.enable = true;
        # media player and stuff
        gvfs.enable = true;
        # change mode power ("preformance", "balanced",...)
      };
      */
    })
]
