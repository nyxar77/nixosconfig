{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.nyx.services.mysql.enable {
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
}
