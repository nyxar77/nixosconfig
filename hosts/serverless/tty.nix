{
  lib,
  pkgs,
  ...
}: {
  console = {
    keyMap = lib.mkForce "fr";
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  services.kmscon = {
    enable = true;
    useXkbConfig = true;
    term = "xterm-256color";
    fonts = [
      {
        name = "JetBrainsMono Nerd Font";
        package = pkgs.nerd-fonts.jetbrains-mono;
      }
      {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      }
    ];
    extraConfig = ''
      font-size=14
    '';
  };

  services.getty.helpLine = "Serverless TTY";
}
