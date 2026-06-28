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

  services.getty.helpLine = ''
    Serverless TTY
      ll      list files
      ff      system summary
      disks   disk usage
      space   directory sizes
      mux     terminal workspace
  '';
  programs.autojump.enable = true;

  programs.zsh.shellAliases = {
    cat = "bat";
    disks = "duf";
    ff = "fastfetch";
    grep = "rg";
    ll = "eza -lah --git --group-directories-first";
    ls = "eza --group-directories-first";
    mux = "tmux";
    space = "dust";
    top = "btop";
  };
}
