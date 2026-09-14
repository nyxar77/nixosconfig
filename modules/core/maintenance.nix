{
  # enable firmware updates
  services = {
    fwupd.enable = true;
    openssh = {
      enable = true;
    };
    journald.extraConfig = ''
      SystemMaxUse=300M
      MaxRetentionSec=14day
    '';
  };

  systemd.coredump.settings.Coredump = {
    MaxUse = "100M";
    KeepFree = "1G";
  };

  boot.tmp.cleanOnBoot = true;
}
