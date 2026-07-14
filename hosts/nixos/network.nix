{...}: {
  programs.mtr.enable = true;

  /*
     services.resolved = {
    enable = true;
    settings.Resolve.FallbackDNS = [
      "1.1.1.3"
      "9.9.9.9"
    ];
  };
  */
  networking = {
    hostName = "nixos";
    /*
       nameservers = [
      "1.1.1.3"
      "9.9.9.9"
    ];
    */

    hosts = {
      "192.168.1.50" = ["serverless"];
      "127.0.0.60" = ["nix.progresso.com"];
      "127.0.0.61" = ["nix.githubfetcher.com"];
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

      insertNameservers = [
        "1.1.1.3"
        "9.9.9.9"
      ];
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
