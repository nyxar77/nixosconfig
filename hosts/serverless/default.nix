{
  lib,
  config,
  ...
}: {
  imports = [
    ./fastfetch.nix
    ./users.nix
    ./hardware-configuration.nix
    ./network.nix
    ./tealdeer.nix
    ./tmux.nix
    ./tty.nix
    ../../modules/profiles/server.nix
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
