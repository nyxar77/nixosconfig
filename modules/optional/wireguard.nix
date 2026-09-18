{
  config,
  hostNames,
  lib,
  ...
}:
let
  cfg = config.nyx.network.wireguard;
  clientPort = 45620;
  serverPort = 51820;
in
lib.mkIf cfg.enable (lib.mkMerge [
  {
    networking.wireguard.enable = true;
  }

  (lib.mkIf (config.nyx.host.name == hostNames.workstation) {
    networking = {
      firewall.allowedUDPPorts = [clientPort];

      wireguard.interfaces.wg0 = {
        ips = ["10.100.0.2/32"];
        listenPort = clientPort;
        privateKeyFile = "/home/nyxar/wireguard-keys/private";
        peers = [
          {
            publicKey = "xBP1ue+funH/xxL5atWZmONwxfw6/m8vG8y9ibhVulY=";
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "serverless-tunnel.ddns.net:${toString serverPort}";
            persistentKeepalive = 25;
            dynamicEndpointRefreshSeconds = 10;
          }
        ];
      };
    };
  })

  (lib.mkIf (config.nyx.host.name == hostNames.server) {
    networking = {
      firewall.allowedUDPPorts = [serverPort];

      nat = {
        enable = true;
        externalInterface = config.nyx.network.hosts.serverless.lanInterface;
        internalInterfaces = ["wg0"];
      };

      wireguard.interfaces.wg0 = {
        ips = ["10.100.0.1/24"];
        listenPort = serverPort;
        privateKeyFile = "/home/baryon/wireguard-keys/private";
        mtu = 1280;
        peers = [
          {
            publicKey = "S/JXC+8QZ7Zn3zpOLIvzSHwU00CRA9FYLTPWNzgLgjw=";
            allowedIPs = ["10.100.0.2/32"];
          }
          {
            publicKey = "8omTwpMeqJKFXQfufVotB1VgQHSe7l9/XAnXnEMywBo=";
            allowedIPs = ["10.100.0.3/32"];
          }
        ];
      };
    };
  })
])
