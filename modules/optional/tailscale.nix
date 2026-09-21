{
  config,
  lib,
  ...
}:
let
  cfg = config.nyx.network.tailscale;
in
lib.mkIf cfg.enable {
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
}
