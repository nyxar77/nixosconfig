{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gtk3
    gtk4
    # ----aesthetics----
    pipes
    tty-clock
    cava
    spicetify-cli
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
    unstable.ags
    unstable.astal.astal4
    unstable.astal.io
    libgtop
    upower
    matugen
    hyprpicker
    flameshot # screenshots

    #--- hyprpanel dependencies ---
    /*
        aylurs-gtk-shell-git
        wireplumber
        libgtop
        bluez
    */

  ];
  /*
      # enabling tilting window manager hyperland
        programs.hyprland = {
            enable = true;
            xwayland.enable = true;
        };
        xdg.portal = {
            enable = true;
            extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        };
        services = {
            #Dbus for power management
            upower.enable = true;
            # login manager daemon
            # greetd.enable = true;
            # media player and stuff
            gvfs.enable = true;
            # change mode power ("preformance", "balanced",...)
            power-profiles-daemon.enable = true;
        };
  */
}
