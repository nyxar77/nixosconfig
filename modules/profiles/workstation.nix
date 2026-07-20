{ ... }: {
  imports = [
    ../core
    ../desktop
    ../programs
    ../services
    ../virtualization
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.polkit.enable = true;
  services.printing.enable = true;
}
