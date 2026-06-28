{...}: {
  imports = [
    ../common/general.nix
    ../common/nix-settings.nix
    ./nh.nix
    ./shells.nix
    ../programs/terminal.nix
    ../services/maintenance.nix
  ];

  services.haveged.enable = true;
}
