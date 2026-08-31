{ ... }: {
  imports = [
    ./general.nix
    ./maintenance.nix
    ./nh.nix
    ./nix.nix
    ./shells.nix
    ./terminal.nix
    ../display-manager.nix
  ];
}
