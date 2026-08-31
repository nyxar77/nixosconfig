{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.nyx.desktop;
in
  lib.mkIf (cfg.enable && cfg.session == "hyprland") {
    console = {
      keyMap = lib.mkForce "fr";
      useXkbConfig = true;
    };

    services.xserver.enable = true;

    services.displayManager.defaultSession = "hyprland-uwsm";

    services.xserver.xkb = {
      layout = "fr";
      variant = "azerty";
    };

    programs.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      withUWSM = true;
      xwayland.enable = true;
    };

    #ATT: disabled
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

      upower.enable = true;
    };

    xdg.portal = {
      enable = true;

      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        # xdg-desktop-portal-wlr
      ];

      config = {
        common = {
          default = [
            "hyprland"
            "gtk"
          ];

          "org.freedesktop.impl.portal.ScreenCast" = ["hyprland"];
          "org.freedesktop.impl.portal.Screenshot" = ["hyprland"];
          "org.freedesktop.impl.portal.GlobalShortcuts" = ["hyprland"];

          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          "org.freedesktop.impl.portal.AppChooser" = ["gtk"];
        };

        hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];

          "org.freedesktop.impl.portal.ScreenCast" = ["hyprland"];
          "org.freedesktop.impl.portal.Screenshot" = ["hyprland"];
          "org.freedesktop.impl.portal.GlobalShortcuts" = ["hyprland"];

          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
          "org.freedesktop.impl.portal.AppChooser" = ["gtk"];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      kdePackages.qt6ct
      kdePackages.qtstyleplugin-kvantum
      pinentry-qt
      sddm-astronaut
      # Caelestia/Hyprland helpers referenced by the dots or useful in this session.
      # System session pieces stay here; per-user helpers live in Home Manager.
      # hyprcursor

      # Optional local tools. Keep disabled until something actually uses them.
      # awww # Wallpaper daemon; Caelestia handles wallpapers through its own shell/CLI.
      # cava # Terminal visualizer, not the libcava library Caelestia shell needs.
      # flameshot # Redundant with Caelestia screenshots and grim/slurp/swappy.
      # flavours # Redundant while Caelestia owns colours.
      # gtk-layer-shell # Old AGS/Hyprpanel dependency, not needed by Caelestia here.
      # gtk3 # Libraries should come from app deps unless you need GTK tools directly.
      # gtk4 # Libraries should come from app deps unless you need GTK tools directly.
      # hyprshot # Redundant with Caelestia screenshots and grim/slurp/swappy.
      # libdbusmenu-gtk3 # Old panel/tray dependency.
      # libgtop # Old Hyprpanel/system-monitor dependency.
      # matugen # Redundant while Caelestia owns colours.
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
