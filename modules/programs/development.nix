{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # ------ developpement ------
    zip
    unzip
    rar
    /*
    pango
    cairo
    glibc
    */
    #TODO: add a condition later for graphical machines only
    appimage-run
    steam-run
  ];

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
}
