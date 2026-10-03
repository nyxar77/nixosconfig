{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.nyx.services.virtualization.host {
  environment.systemPackages = with pkgs; [
    quickemu
    quickgui
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };

  programs.virt-manager.enable = true;
}
