{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # ------ developpement ------
    tree-sitter
    gnumake
    docker-compose
    google-cloud-sdk
    deno
    bun
    nodejs_24
    libgcc
    luarocks
    lua5_4_compat
    lua5_1
    gcc
    mysql80
    go
    git
    python311
    php83Packages.composer
    nixfmt-rfc-style # format for the nix language
    nixd # lsp for nix
    mongosh
    rustc
    cargo
    nix-tree
    zip
    unzip
    rar
    appimage-run
    steam-run
    libdbusmenu-gtk3
    xdg-utils
    /*
      gtk-layer-shell
      pango
      rubyPackages_3_3.gdk_pixbuf2
      cairo
      rubyPackages_3_3.glib2
      glibc
    */
  ];
}
