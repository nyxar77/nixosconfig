{
  config,
  lib,
  pkgs,
  ...
}: {
  # client config
  config =
    if (config.hosts.host == "nixos")
    then {
      networking.wireguard.enable = false;
      networking.wireguard.interfaces.wg0 = {
        ips = ["10.100.0.2/32"];
        listenPort = 45620;
        privateKeyFile = "/home/nyxar/wireguard-keys/private";
        peers = [
          {
            publicKey = "xBP1ue+funH/xxL5atWZmONwxfw6/m8vG8y9ibhVulY=";
            allowedIPs = ["0.0.0.0/0"];
            endpoint = "serverless-tunnel.ddns.net:51820";
            persistentKeepalive = 25;
            dynamicEndpointRefreshSeconds = 10;
          }
        ];
      };
    }
    else if (config.hosts.host == "serverless")
    then {
      networking.wireguard.enable = false;
      networking.wireguard.interfaces.wg0 = {
        ips = ["10.100.0.1/24"];
        listenPort = 51820;
        privateKeyFile = "/home/baryon/wireguard-keys/private";
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp1s0 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp1s0 -j MASQUERADE
        '';
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
    }
    else {};
}
