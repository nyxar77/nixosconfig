{pkgs, ...}: {
  programs = {
    thunderbird.enable = true;
    nix-ld.enable = true;
    neovim.enable = true;
    zsh.enable = true;
  };
  programs.steam = {
    enable = true;

    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
        OBS_VKCAPTURE = true;
        RADV_TEX_ANISO = 16;
      };
    };
  };

  # enable hotspot
  # services.create_ap.enable = true;
  # List packages installed in system profile. To search, run:

  environment.systemPackages = with pkgs; [
    prismlauncher
    aircrack-ng
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #---- disk / partition related packages ----
    disko # format and changing fs in a declarative way
    ntfs3g
    gparted
    parted
    testdisk
    usbutils

    #-------------------
    linuxKernel.packages.linux_zen.v4l2loopback # virtual camera
    # linux-wifi-hotspot
    # ------------------

    # ------------------------
    mtr-gui
    winetricks
    wineWowPackages.waylandFull
    blender-hip
    waydroid
  ];
}
