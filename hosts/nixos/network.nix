{...}: {
  programs.mtr.enable = true;

  services.dnscrypt-proxy = {
    enable = true;
    upstreamDefaults = false;
    settings = {
      listen_addresses = ["127.0.0.1:53"];
      server_names = [
        "cloudflare-family"
        "quad9-filtered"
      ];

      ipv4_servers = true;
      ipv6_servers = false;
      dnscrypt_servers = false;
      doh_servers = true;
      odoh_servers = false;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = false;
      ignore_system_dns = true;
      netprobe_address = "1.1.1.1:443";

      cache = true;
      cache_size = 4096;

      static = {
        cloudflare-family.stamp = "sdns://AgMAAAAAAAAABzEuMC4wLjMABzEuMC4wLjMKL2Rucy1xdWVyeQ";
        quad9-filtered.stamp = "sdns://AgMAAAAAAAAABzkuOS45LjkgsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8SZG5zOS5xdWFkOS5uZXQ6NDQzCi9kbnMtcXVlcnk";
      };
    };
  };

  networking = {
    hostName = "nixos";

    hosts = {
      "192.168.1.50" = ["serverless"];
    };

    nat = {
      enable = true;
      internalInterfaces = ["wg0"];
    };

    networkmanager = {
      enable = true;
      dns = "none";
      wifi.backend = "iwd";
      wifi.powersave = false;
    };

    wireless.iwd = {
      enable = true;
      settings = {
        Network.EnableIPv6 = false;
        Settings.AutoConnect = true;
      };
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [
        4242
        44562
        51413
        51820
        80
        443
      ];
      allowedUDPPorts = [
        80
        443
        4242
        51413
        44562
        51820
      ];
    };
  };
}
