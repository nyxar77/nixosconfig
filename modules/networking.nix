{ ... }:
{
  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "wg0" ];

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
