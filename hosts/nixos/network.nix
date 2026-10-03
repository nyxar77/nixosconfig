{
  config,
  hostNames,
  pkgs,
  ...
}:
let
  serverlessAddress = config.nyx.network.hosts.serverless.ipv4;
in
{
  programs.mtr.enable = true;

  services.dnscrypt-proxy = {
    enable = true;
    upstreamDefaults = false;
    settings = {
      listen_addresses = [ "127.0.0.1:53" ];
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

  services.hostapd = {
    enable = true;
    radios.ap0 = {
      band = "5g";
      channel = 44;
      countryCode = "MA";
      networks.ap0 = {
        ssid = "I-nixos";
        authentication = {
          mode = "wpa2-sha1";
          wpaPasswordFile = config.sops.secrets.wifi-hotspot-password.path;
        };
      };
    };
  };

  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      interface = "ap0";
      except-interface = "lo";
      bind-interfaces = true;
      dhcp-authoritative = true;
      dhcp-range = [ "10.42.0.10,10.42.0.254,255.255.255.0,12h" ];
      dhcp-option = [
        "option:router,10.42.0.1"
        "option:dns-server,10.42.0.1"
      ];
      server = [ "127.0.0.1#53" ];
    };
  };

  networking = {
    hosts = {
      "${serverlessAddress}" = [ hostNames.server ];
    };

    networkmanager = {
      enable = true;
      dns = "none";
      wifi.backend = "iwd";
      wifi.powersave = true;
      unmanaged = [ "interface-name:ap0" ];
    };

    wireless.iwd = {
      enable = true;
      settings = {
        Network.EnableIPv6 = false;
        Settings.AutoConnect = true;
      };
    };

    interfaces.ap0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.42.0.1";
          prefixLength = 24;
        }
      ];
    };

    nat = {
      enable = true;
      externalInterface = "wlan0";
      internalInterfaces = [ "ap0" ];
    };

    firewall = {
      enable = true;
      interfaces.ap0 = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [
          53
          67
        ];
      };
      allowedTCPPorts = [
        # 80 # Local web server
        # 443 # Local web server
        # 4242
        # 44562
        # 51413 # BitTorrent
      ];
      allowedUDPPorts = [
        # 80
        # 443
        # 4242
        # 44562
        # 51413 # BitTorrent
      ];
    };
  };

  systemd.services.wifi-ap-interface = {
    description = "Create the virtual Wi-Fi hotspot interface";
    wantedBy = [ "multi-user.target" ];
    requiredBy = [ "NetworkManager.service" ];
    before = [ "NetworkManager.service" ];
    requires = [ "sys-subsystem-net-devices-wlan0.device" ];
    after = [ "sys-subsystem-net-devices-wlan0.device" ];
    path = [
      pkgs.iproute2
      pkgs.iw
    ];
    script = ''
      if ! ip link show ap0 >/dev/null 2>&1; then
        iw dev wlan0 interface add ap0 type __ap addr 16:13:33:f2:38:d1
      fi
    '';
    preStop = ''
      if ip link show ap0 >/dev/null 2>&1; then
        iw dev ap0 del
      fi
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  systemd.services.dnsmasq = {
    requires = [ "network-addresses-ap0.service" ];
    after = [ "network-addresses-ap0.service" ];
  };
}
