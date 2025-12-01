{
  hostRole,
  lib,
  ...
}: let
in
  lib.mkMerge [
    (lib.mkIf
      (hostRole == "nixos")
      {
        programs.mtr.enable = true;
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
        };

        networking.wireless.iwd.enable = true;

        # Open ports in the firewall.
        networking.firewall = {
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
      })
    (lib.mkIf
      (hostRole == "serverless")
      {
        programs.mtr.enable = true;
        #DANGER: networking

        networking.networkmanager = {
          enable = false;
        };
        networking.wireless.iwd.enable = true;
        networking.wireless.iwd.settings = {
          Network = "";
          Settings = "";
        };

        networking.hostName = "serverless"; # Define your hostname.

        /*
        networking.wireless = {
          enable = true;
          networks = {
            "ADSL-2.4" = {
              psk = "301F482016E8"; # Replace with your actual Wi-Fi password
            };
          };
        };
        */

        networking.interfaces = {
          /*
          wlp2s0 = {
            useDHCP = false;
            ipv4.addresses = [
              {
                address = "192.168.1.50";
                prefixLength = 24;
              }
            ];
          };
          */
          enp1s0 = {
            useDHCP = false;
            ipv4.addresses = [
              {
                address = "192.168.1.50";
                prefixLength = 24;
              }
            ];
          };
        };
        networking.nameservers = [
          "9.9.9.9"
          "94.140.14.14"
        ];

        networking.defaultGateway = {
          address = "192.168.1.1";
          interface = "enp1s0";
        };
        networking.nat = {
          enable = true;
          # externalInterface = "enp1s0";
          internalInterfaces = ["wg0"];
        };

        # Open ports in the firewall.
        networking.firewall = {
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
      })
  ]
