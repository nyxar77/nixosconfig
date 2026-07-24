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
    hostName = "serverless";

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

    interfaces.enp1s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.50";
          prefixLength = 24;
        }
      ];
    };

    nameservers = ["127.0.0.1"];

    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp1s0";
    };

    nat = {
      enable = true;
      internalInterfaces = ["wg0"];
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [
        51820
      ];
      allowedUDPPortRanges = [
        {
          from = 60000;
          to = 60004;
        }
      ];
    };
  };
}
