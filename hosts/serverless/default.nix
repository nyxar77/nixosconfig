{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./users.nix
    ./hardware-configuration.nix
    ./network.nix
    ../../modules/profiles/server.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nyx = {
    host = {
      name = "serverless";
      role = "server";
    };

    desktop.enable = false;
    hardware.fingerprint = false;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "rar"
      "steam-unwrapped"
    ];

  nixpkgs.config.permittedInsecurePackages = [
    "intel-media-sdk-23.2.2"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [intel-media-sdk];
  };

  system.stateVersion = "24.11";
}
