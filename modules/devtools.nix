{
  lib,
  pkgs,
  ...
}: {
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
    xdg-utils
    appimage-run
    steam-run
    mycli
    oracle-instantclient
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
