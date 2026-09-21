{
  lib,
  config,
  ...
}: {
  imports = [
    ./disko.nix
    ./users.nix
    ./hardware-configuration.nix
    ./network.nix
    ./secrets.nix
    ./memory.nix
    ./tty.nix
    ../../modules/profiles/server.nix
    ../../modules/optional/remote-builder.nix
    ../../modules/services/attic.nix
    ../../modules/services/immich.nix
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
    network.tailscale.enable = true;

    services.attic = {
      enable = true;
      server = true;
    };
    services.immich.enable = true;
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
  services = {
    irqbalance.enable = true;
    thermald.enable = true;

    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    smartd = {
      enable = true;
      autodetect = true;
    };
  };

  system.stateVersion = "24.11";
}
