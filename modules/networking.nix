{ ... }:
{
  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "wg0" ];

  # Open ports in the firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      4242
      51820
      44562
    ];
    allowedUDPPorts = [
      4242
      51820
      44562
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
