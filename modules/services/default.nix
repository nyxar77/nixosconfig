{
  config,
  lib,
  ...
}: {
  imports = [
    ./keyd.nix
    ./sound.nix
    ./virtualisation.nix
    ./vm.nix
    ./maintenance.nix
    ./apache.nix
  ];
  /*
     ++ lib.optionals config.fingerprintSupported [
    ./fingerprint.nix
  ];
  */

  services = {
    gvfs.enable = true; # NOTE: automount/umount
    haveged.enable = true; # NOTE: this is for entropy (generate randomness)
    # Enable CUPS to print documents.
    printing.enable = true;
    udev.enable = true;
    #--------
  };
}
