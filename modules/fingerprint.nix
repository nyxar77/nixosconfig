{ pkgs, ... }:
{
  # enable firmware updates
  services.fwupd.enable = true;

  # Enable fingerprint.
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-elan;
  };
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };
}
