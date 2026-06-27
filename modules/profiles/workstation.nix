{...}: {
  imports = [
    ../base
    ../powerManagement.nix
    ../devtools.nix
    ../GUI
    ../common/fonts-configuration.nix
    ../desktop/audio.nix
    ../desktop/bluetooth.nix
    ../programs/capture-tools.nix
    ../programs/desktop-tools.nix
    ../programs/disk-tools.nix
    ../programs/file-manager.nix
    ../programs/mail.nix
    ../programs/nix-ld.nix
    ../programs/steam.nix
    ../programs/syncthing.nix
    ../programs/wifi-tools.nix
    ../services/apache.nix
    ../services/fingerprint.nix
    ../services/keyd.nix
    ../services/mysql.nix
    ../services/virtualisation.nix
    ../virtualization/libvirt-host.nix
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.polkit.enable = true;
  services.printing.enable = true;
}
