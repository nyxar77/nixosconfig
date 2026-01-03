{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    bridge-utils
    qemu_kvm
    libosinfo
    libvirt
    swtpm
    quickemu
    #        quickgui
  ];
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      verbatimConfig = ''
        nvram = [
           "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd"
         ]'';
      /*
         ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
      */
    };
  };
  programs.virt-manager.enable = true;
}
