{ ... }:

{
  networking.wireguard.enable = true;

  # server it would communicate with
  networking.wireguard.interfaces =
    let
      server_ip = "1";
      hostname = "serverless-tunnel.ddns.net";
    in
    {
      wg0 = {
        ips = [ "10.100.0.2/32" ];
        listenPort = 445620;
        # generatePrivateKeyFile = true;
        privateKeyFile = "/home/nyxar/wireguard-keys/private";
        # mtu = 1280;

        peers = [
          {
            # baryon(Nixos)
            publicKey = "xBP1ue+funH/xxL5atWZmONwxfw6/m8vG8y9ibhVulY=";
            allowedIPs = [ "0.0.0.0/0" ];
            # endpoint = "${hostname}:51820";
            endpoint = "${hostname}:51820";
            persistentKeepalive = 25;
            dynamicEndpointRefreshSeconds = 10;
          }
        ];
      };
    };
}
