{...}: {
  imports = [
    ../common/general.nix
    ../common/nix-settings.nix
    ./shells.nix
    ../programs/terminal.nix
    ../services/maintenance.nix
  ];

  services.haveged.enable = true;
}
