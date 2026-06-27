{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.nyx.desktop;
  # hyprlandPkgs = inputs.prevPkgs.legacyPackages.${pkgs.system};
in
  lib.mkIf (cfg.enable && cfg.session == "hyprland") {
    services.displayManager = {
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
      };
    };

    programs.hyprland = {
      enable = true;
      /*
         package = hyprlandPkgs.hyprland;
      portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
      */
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      withUWSM = true;
      xwayland.enable = true;
    };

    # programs.hyprlock.enable = true;

    /*
       programs.regreet = {
      enable = true;
      theme = lib.mkForce {
        package = pkgs.sweet;
        name = "Sweet-Dark";
      };
      iconTheme = lib.mkForce {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
      font = lib.mkForce {
        package = pkgs.inter;
        name = "Inter";
        size = 16;
      };
      cursorTheme = lib.mkForce {
        package = pkgs.catppuccin-cursors.mochaMauve;
        name = "catppuccin-mocha-red-cursors";
      };
    };
    */

    services = {
      greetd = {
        enable = false;
        settings = {
          default_session = {
            user = "greeter";
            command = lib.mkForce "${pkgs.dbus}/bin/dbus-run-session ${pkgs.coreutils}/bin/env XKB_DEFAULT_LAYOUT=fr XKB_DEFAULT_VARIANT=azerty ${lib.getExe pkgs.cage} -s -d -- ${lib.getExe config.programs.regreet.package}";
          };
        };
      };

      gvfs.enable = true;
      # hypridle is user-scoped and enabled in Home Manager.
      upower.enable = true;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = ["hyprland" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        };
        hyprland = {
          default = ["hyprland" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        };
        Hyprland = {
          default = ["hyprland" "gtk"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      # Caelestia/Hyprland helpers referenced by the dots or useful in this session.
      # System session pieces stay here; per-user helpers live in Home Manager.
      # hyprcursor
      pinentry-qt

      # Optional local tools. Keep disabled until something actually uses them.
      # awww # Wallpaper daemon; Caelestia handles wallpapers through its own shell/CLI.
      # cava # Terminal visualizer, not the libcava library Caelestia shell needs.
      # flameshot # Redundant with Caelestia screenshots and grim/slurp/swappy.
      # flavours # Redundant if Caelestia/Stylix owns colours.
      # gtk-layer-shell # Old AGS/Hyprpanel dependency, not needed by Caelestia here.
      # gtk3 # Libraries should come from app deps unless you need GTK tools directly.
      # gtk4 # Libraries should come from app deps unless you need GTK tools directly.
      # hyprshot # Redundant with Caelestia screenshots and grim/slurp/swappy.
      # libdbusmenu-gtk3 # Old panel/tray dependency.
      # libgtop # Old Hyprpanel/system-monitor dependency.
      # matugen # Redundant if Caelestia/Stylix owns colours.
      # mpd-small # Only needed if you actually run an MPD setup.
      # ncmpcpp # Only useful with MPD.
      # networkmanager_dmenu # Caelestia has its own network UI; NetworkManager is enabled globally.
      # pipes # Terminal toy.
      # rofi # Caelestia provides the launcher.
      # rofi-bluetooth # Not needed unless you prefer this over Caelestia/Bluetooth tooling.
      # rofi-emoji # Caelestia provides emoji picker binds.
      # tty-clock # Terminal toy.
    ];
  }
