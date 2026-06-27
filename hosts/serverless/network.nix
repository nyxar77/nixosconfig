{...}: {
  programs.mtr.enable = true;

  networking = {
    hostName = "serverless";

    networkmanager = {
      enable = false;
      dns = "none";
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

    nameservers = [
      "9.9.9.9"
      "94.140.14.14"
    ];

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
