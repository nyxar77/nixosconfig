{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bridge-utils
    qemu_kvm
    libosinfo
    libvirt
    virt-manager
    swtpm
    quickemu
    #        quickgui
  ];
  virtualisation.libvirtd = {
    enable = true;
    /*
      qemu = {
           package = pkgs.qemu_kvm; # only emulates host arch, smaller download
           runAsRoot = true;
           swtpm.enable = true;
           ovmf = {
             enable = true;
             packages = [
               (pkgs.OVMF.override {
                  secureBoot = true;
                  tpmSupport = true;
               }).fd
             ];
           };
         };
    */
  };
  programs.virt-manager.enable = false;

}
