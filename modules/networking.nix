{...}: {
  networking.nat = {
    enable = true;
    internalInterfaces = ["wg0"];
  };

  networking.networkmanager = {
    enable = true;
    insertNameservers = [
      "1.1.1.3"
      "9.9.9.9"
    ];
  };
  networking.hosts = {
    "192.168.1.50" = ["serverless"];
    "192.168.1.51" = ["serverlesss"];
  };

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      4242
      44562
      51413
      51820
    ];
    allowedUDPPorts = [
      4242
      51413
      44562
      51820
    ];

    /*
    allowedTCPPortRanges = [
      {
        from = 2000;
        to = 4000;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 2000;
        to = 4000;
      }
    ];
    */
  };
}
