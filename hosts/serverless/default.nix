{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./users.nix
    ./hardware-configuration.nix
    ../../modules
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hosts.host = "serverless";
  desktopManagers = {
    enable = false;
  };
  fingerprintSupported = false;

  networking.hostName = "serverless";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [intel-media-sdk];
  };

  system.stateVersion = "24.11";
}
