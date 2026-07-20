{ ... }: {
  # enable firmware updates
  services.fwupd.enable = true;

  services.openssh = {
    enable = true;
    /*
    extraConfig = ''
      Host serverless
        HostName 192.168.1.51
        User baryon
        IdentityFile /home/nyxar/.ssh/serverless
    '';
    */
  };
  services.journald.extraConfig = ''
    SystemMaxUse=300M
    MaxRetentionSec=14day
  '';

  systemd.coredump.settings.Coredump = {
    MaxUse = "100M";
    KeepFree = "1G";
  };

  boot.tmp.cleanOnBoot = true;
}
