{pkgs, ...}: {
  # enable hotspot
  # services.create_ap.enable = true;
  # List packages installed in system profile. To search, run:

  environment.systemPackages = with pkgs; [
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
