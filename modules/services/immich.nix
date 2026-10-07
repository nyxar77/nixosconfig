{
  config,
  lib,
  unstablePkgs,
  ...
}:
let
  cfg = config.nyx.services.immich;
  mediaLocation = "/srv/immich";
  lanInterface = config.nyx.network.hosts.serverless.lanInterface;
in
lib.mkIf cfg.enable (
  lib.mkMerge [
    {
      services.immich = {
        enable = true;
        package = unstablePkgs.immich;
        host = "0.0.0.0";
        inherit mediaLocation;
      };

      systemd.tmpfiles.rules = [
        "d ${mediaLocation} 0700 immich immich -"
      ];

      networking.firewall.interfaces.${lanInterface}.allowedTCPPorts = [
        config.services.immich.port
      ];
    }

    (lib.mkIf config.nyx.network.tailscale.enable {
      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
        config.services.immich.port
      ];
    })
  ]
)
