{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # ------ developpement ------
    tree-sitter
    gnumake
    gcc
    libgcc
    zip
    unzip
    rar
    /*
    pango
    rubyPackages_3_3.gdk_pixbuf2
    cairo
    rubyPackages_3_3.glib2
    glibc
    */
    #TODO: add a condition later for graphical machines only
    xdg-utils
    appimage-run
    steam-run
  ];
}
