{
  config,
  hostNames,
  pkgs,
  ...
}:
{
  imports = [
    ./users.nix
    ./hardware-configuration.nix
    ./memory.nix
    ./network.nix
    ./secrets.nix
    ./web.nix
    ../../modules/profiles/workstation.nix
  ];

  nyx = {
    desktop = {
      enable = true;
      session = "hyprland";
    };

    displayManager = "sddm";

    hardware.fingerprint = true;

    network.tailscale.enable = false;

    services = {
      attic.enable = true;
      mysql.enable = false;
      steam.enable = true;
      syncthing.enable = true;
      web.enable = false;
      virtualization.host = false;
    };
  };

  nix = {
    distributedBuilds = true;
    buildMachines = [
      {
        hostName = hostNames.server;
        protocol = "ssh-ng";
        system = "x86_64-linux";
        sshUser = "remotebuild";
        sshKey = config.sops.secrets.ssh-remote-builder.path;
        maxJobs = 1;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
      }
    ];
    settings.builders-use-substitutes = true;
  };

  programs.ssh.knownHosts.${hostNames.server} = {
    hostNames = [
      hostNames.server
      config.nyx.network.hosts.serverless.ipv4
    ];
    publicKeyFile = ../../files/serverless-host.pub;
  };

  environment.pathsToLink = [ "/share/zsh" ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_zen;
    # kernelPackages = pkgs.linuxPackages_cachyos;
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1

      options rtw89_core disable_ps_mode=y
      options rtw89_pci disable_clkreq=y disable_aspm_l1=y disable_aspm_l1ss=y
    '';
  };

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
