{
  lib,
  config,
  ...
}: {
  imports = [
    ./users.nix
    ./hardware-configuration.nix
    ./network.nix
    ./secrets.nix
    ./memory.nix
    ./tty.nix
    ../../modules/profiles/server.nix
    ../../modules/services/attic.nix
    ../../modules/services/scx.nix
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  nyx = {
    desktop.enable = false;
    displayManager = "ly";
    hardware.fingerprint = false;

    services.attic = {
      enable = true;
      server = true;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "rar"
      "steam-unwrapped"
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  powerManagement.cpuFreqGovernor = "performance";
  services.thermald.enable = true;
  services.irqbalance.enable = true;

  system.stateVersion = "24.11";
}
