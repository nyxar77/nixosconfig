{
  config,
  lib,
  ...
}: {
  imports = [
    ./network.nix
    ./powerManagement.nix
    # ./wireguard.nix
    ./later.nix
    ./devtools.nix
    ./programs
    ./services
    ./common
    ./GUI
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
