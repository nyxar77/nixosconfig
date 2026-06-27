{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    disko
    gparted
    ntfs3g
    parted
    testdisk
    usbutils
    vim
  ];
}
