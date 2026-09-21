{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nyx.displayManager;
  silentSddmMenuButtonStyle = {
    background-color = "#294654";
    background-opacity = 0.78;
    active-background-color = "#ffb347";
    active-background-opacity = 1.0;
    content-color = "#f3fbff";
    active-content-color = "#101922";
    border-size = 1;
    border-color = "#8ecde0";
  };
  /*
    sddm-astronaut = pkgs.sddm-astronaut.override {
      embeddedTheme = "pixel_sakura";
      themeConfig = {
        HeaderText = "Welcome back, nyxar!";
        DateFormat = "dddd, MMMM d";
        HourFormat = "HH:mm";
        HeaderTextColor = "#d5c4a1";
        DateTextColor = "#d5c4a1";
        TimeTextColor = "#ebdbb2";
        FormBackgroundColor = "#1d2021";
        Background = "Backgrounds/pixel_sakura.gif";
      };
    };
  */
in
{
  config = lib.mkMerge [
    (lib.mkIf (cfg == "ly") {
      services.displayManager.ly = {
        enable = true;
        settings = {
          load = true;
          save = true;
          animation = "dur_file";
          dur_file_path = toString (
            pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/nyxar77/homeconfig/refs/heads/master/assets/animated/blackhole-smooth.dur";
              hash = "sha256-wo3FzPtngCsg/bRSDTYHQqKnMp4vY+Btm14vakJERBU=";
            }
          );
          dur_offset_alignment = "center";
        };
      };
    })
    (lib.mkIf (cfg == "sddm") {

      programs.silentSDDM = {
        enable = true;
        theme = "nord";

        backgrounds.fireplace = pkgs.fetchurl {
          name = "fireplace.mp4";
          url = "https://raw.githubusercontent.com/nyxar77/homeconfig/master/assets/animated/fireplace.mp4";
          hash = "sha256-ciYmh+WsfKuw1moBkAMHJklU18rx2jKXpXXnK9Xl+w0=";
        };
        profileIcons.nyxar = pkgs.fetchurl {
          name = "hm.jpg";
          url = "https://raw.githubusercontent.com/nyxar77/homeconfig/blob/master/assets/profiles/hm.jpg";
          hash = "sha256-P7f6cK9rOWqjDjiXgjeOp8iUFiyC43qUbVMBaOtGkM0=";
        };

        settings = {
          "General" = {
            enable-animations = true;
            background-fill-mode = "fill";
          };

          "LockScreen" = {
            display = false;
          };

          "LoginScreen" = {
            background = "fireplace.mp4";
            use-background-color = false;
            brightness = -0.08;
            saturation = 0.05;
          };

          "LoginScreen.LoginArea" = {
            position = "right";
            margin = 72;
          };

          "LoginScreen.LoginArea.Avatar" = {
            active-border-color = "#ffb347";
            inactive-border-color = "#70bfd4";
            active-border-size = 2;
            inactive-border-size = 1;
          };

          "LoginScreen.LoginArea.Username" = {
            font-family = "Departure Mono";
            font-size = 18;
            font-weight = 400;
            color = "#d7edf4";
          };

          "LoginScreen.LoginArea.PasswordInput" = {
            font-family = "Departure Mono";
            font-size = 14;

            content-color = "#d7edf4";
            background-color = "#101922";
            background-opacity = 0.82;

            border-size = 2;
            border-color = "#70bfd4";
            border-radius-left = 3;
            border-radius-right = 3;
          };

          "LoginScreen.LoginArea.LoginButton" = {
            font-family = "Departure Mono";
            font-size = 14;
            font-weight = 400;

            content-color = "#ffb347";
            active-content-color = "#101922";

            background-color = "#101922";
            background-opacity = 0.82;
            active-background-color = "#ffb347";
            active-background-opacity = 1.0;

            border-size = 2;
            border-color = "#ffb347";
            border-radius-left = 3;
            border-radius-right = 3;
          };

          "LoginScreen.LoginArea.Spinner" = {
            font-family = "Departure Mono";
            color = "#ffb347";
          };

          "LoginScreen.LoginArea.WarningMessage" = {
            font-family = "Departure Mono";
            normal-color = "#94b8c7";
            warning-color = "#ffb347";
            error-color = "#ef6a45";
          };

          "LoginScreen.MenuArea.Buttons" = {
            font-family = "Departure Mono";
            border-radius = 3;
          };

          "LoginScreen.MenuArea.Session" = silentSddmMenuButtonStyle;
          "LoginScreen.MenuArea.Layout" = silentSddmMenuButtonStyle;
          "LoginScreen.MenuArea.Keyboard" = silentSddmMenuButtonStyle;
          "LoginScreen.MenuArea.Power" = silentSddmMenuButtonStyle;

          "LoginScreen.MenuArea.Popups" = {
            font-family = "Departure Mono";

            background-color = "#182832";
            background-opacity = 0.97;

            content-color = "#f3fbff";
            active-option-background-color = "#ffb347";
            active-option-background-opacity = 1.0;
            active-content-color = "#101922";

            border-size = 1;
            border-color = "#8ecde0";
          };
        };
      };

      services.displayManager.sddm.autoNumlock = true;

      /*
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
        environment.systemPackages = [ sddm-astronaut ];
      */
    })
  ];
}
