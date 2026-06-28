{lib, ...}: {
  console = {
    keyMap = lib.mkForce "fr";
    font = "Lat2-Terminus16";
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
    mux = "zellij";
    space = "dust";
    top = "btop";
  };
}
