{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.nyx.services.mysql.enable {
  services.mysql = {
    enable = false;
    package = pkgs.mariadb;
  };
  environment.systemPackages = [pkgs.mycli];
}
