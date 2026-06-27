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

  hosts.host = "nixos";
  desktopManagers = {
    enable = true;
    mode = "hyprland";
  };
  fingerprintSupported = true;

  environment.pathsToLink = ["/share/zsh"];
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.kernelModules = ["amdgpu"];

  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1

    options rtw89_core disable_ps_mode=y
    options rtw89_pci disable_clkreq=y disable_aspm_l1=y disable_aspm_l1ss=y
  '';

  hardware.enableAllFirmware = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    /*
       extraPackages = with pkgs; [amdvlk];
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
    */
  };

  system.stateVersion = "23.11";
}
