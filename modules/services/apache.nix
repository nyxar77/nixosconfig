{config, lib, ...}:
lib.mkIf config.nyx.services.web.enable {
  services.httpd = {
    enable = true;
    enablePHP = true;
  };
}
