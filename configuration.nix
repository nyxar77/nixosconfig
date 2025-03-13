# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}@args:

{
  imports = [
    # Include the results of the hardware scan.
    ./vm.nix
    ./fonts-configuration.nix
    ./terminal.nix
    ./developement.nix
    ./modules/wireguard.nix
    ./modules/syncthing.nix
    ./modules/fingerprint.nix
    ./modules/hyprland.nix
    ./modules/networking.nix
    ./modules/desktop-manager.nix
    ./modules/applets.nix
  ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import <unstable> { }; # Load the unstable package set
    };
  };
  # Bootloader:
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.initrd.kernelModules = [ "amdgpu" ];
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # hibernation

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hosts = {
    "192.168.1.50" = [ "serverless" ];
    "192.168.1.51" = [ "serverlesss" ];
  };
  networking = {
    nameservers = [
      "1.1.1.1"
      /*
        "9.9.9.9"
        "149.112.112.112"
      */
    ]; # Cloudflare's malware-filtering DNS
  };

  # Set your time zone.
  time.timeZone = "Africa/Casablanca";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {

    LC_NUMERIC = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;
  /*
    services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    layout = "fr";
    xkbVariant = "azerty";
    };
  */
  # Configure console keymap
  console.keyMap = "fr";

  # enable bluetooth
  hardware.bluetooth.enable = true;
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow experimental feature "flakes"
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    # Default shell
    defaultUserShell = pkgs.fish;
    users.nyxar = {
      isNormalUser = true;
      description = "Nyxar";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "libvirt"
        "adbusers"
        "plugdev"
      ];
      # packages = with pkgs; [];
    };
  };

  programs = {
    ladybird.enable = true;
    thunderbird.enable = true;
    kdeconnect.enable = true;
    firefox.enable = true;
    steam.enable = true;
    nix-ld.enable = true;
    neovim.enable = true;
    fish.enable = true;
    xwayland.enable = true;
  };

  programs.zsh = {
    enable = true;
    /*
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        edit = "sudo -e";
        update = "sudo nixos-rebuild switch";
      };

      history.size = 10000;
      history.ignoreAllDups = true;
      history.path = "$HOME/.zsh_history";
      history.ignorePatterns = [
        "rm *"
        "pkill *"
        "cp *"
      ];
    */
  };

  #  programs.firefox.nativeMessagingHosts.packages = [ pkgs.uget-integrator ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # enable hotspot
  # services.create_ap.enable = true;
  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #---- disk / partition related packages ----
    disko # format and changing fs in a declarative way
    ntfs3g
    gparted
    parted
    gnome-disk-utility
    testdisk
    usbutils
    ventoy-full
    #--- password manager ---
    keepassxc
    # entropy daemon
    scrcpy
    android-tools
    #-------------------
    figma-linux
    mpv
    obs-studio
    linuxKernel.packages.linux_zen.v4l2loopback # virtual camera
    # linux-wifi-hotspot
    brave
    # ------------------
    lan-mouse

    # ------------------------
    mtr-gui
    winetricks
    wineWowPackages.waylandFull
    blender-hip
    vesktop
    discover-overlay # overlay for audio
    spotify
    obsidian
    libreoffice # alternative for microsoft office
    hunspell # spellchecker
    hunspellDicts.en_US # english_usa
    hunspellDicts.fr-any # french - any variant
    mangohud
    goverlay
    waydroid
    #uget # download manager
    xonotic
    wesnoth
    superTuxKart
    unstable.bolt-launcher
    (prismlauncher.override {
      jdks = [
        jdk8
        jdk17
        jdk21_headless
      ];
    })
    torrential
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  /*
    programs.mpv = {
      enable = true;

      package = (
        pkgs.mpv-unwrapped.wrapper {
          scripts = with pkgs.mpvScripts; [
            uosc
            sponsorblock
          ];

          mpv = pkgs.mpv-unwrapped.override {
            waylandSupport = true;
          };
        }
      );

      config = {
        profile = "high-quality";
        ytdl-format = "bestvideo+bestaudio";
        cache-default = 4000000;
      };
    };
  */

  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      #longview.mysqlPasswordFile = "/run/keys/mysql.password";
    };
  };
  services = {
    gvfs.enable = true; # NOTE: automount/umount
    haveged.enable = true; # enable rng (haveged) #NOTE: this is for entropy (generate randomness)
  };
  #-----------
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    udev.enable = true;
    #--------
  };
  services = {
    # anti-virus
    clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
  };

  virtualisation.waydroid.enable = true;
  virtualisation.docker = {
    # enable docker
    enable = true;
    # use docker without Root access (Rootless docker)
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    # change docker images default path
    /*
      daemon.settings = {
          data-root = "~/Programming/Coding/docker/images/";
      };
    */
  };

  # nix-garbage-collect every 5 days
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 5d";
  };
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  system.copySystemConfiguration = true;

  system.stateVersion = "24.11"; # Did you read the comments? no :(
}
