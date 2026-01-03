{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf (config.fingerprintSupported) {
  # Enable fingerprint.
  services.fprintd = {
    enable = true;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-elan;
  };
  systemd.services.fprintd = {
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "simple";
  };
}
