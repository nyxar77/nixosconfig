{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.nyx.services.virtualization.host {
  environment.systemPackages = with pkgs; [
    bridge-utils
    libosinfo
    libvirt
    qemu_kvm
    quickemu
    quickgui
    swtpm
  ];

  virtualisation.libvirtd = {
    enable = true;
    /*
       qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      verbatimConfig = ''
        nvram = [
           "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd"
         ]'';

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

  programs.virt-manager.enable = true;
}
