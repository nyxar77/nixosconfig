{
  hostRole,
  lib,
  ...
}:
lib.mkIf (hostRole == "nixos") {
  services = {
    syncthing = {
      enable = true;
      user = "nyxar";
      dataDir = "/home/nyxar";
      configDir = "/home/nyxar/.config/syncthing";
      openDefaultPorts = true;

      settings = {
        gui = {
          user = "nyxar";
          password = "iWDxPvM$7ZRisfvfd4t%5ZNmtQ`iZY4$XXyCA";
        };
        devices = {
          "reno4" = {
            id = "5O3OEE6-3RNKLDB-ZHYKZ3G-D6AXIUY-6V2M3TU-VW32CSH-RNPGJ6F-LERTJAN";
          };
          "oppo8" = {
            id = "CW7QULU-4C4KCKH-ZOPCZK6-7WYI3WS-26BGYWF-UZHY5PA-UJYACHG-UNXHOQU";
          };
          "Nothing" = {
            id = "PBV6J2C-SO5UDW7-LEZGYP3-PPZIJVI-C5Y3UET-COISGYN-67LTTFY-CSMGZAV";
          };
        };
        folders = let
          userDir = "/home/nyxar";
          devices = [
            "reno4"
            # "oppo8"
            "Nothing"
          ];
        in {
          "keepass" = {
            id = "xkarx-qj2wy";
            path = "${userDir}/Documents/KeePass/Group1/";
            devices = devices;
          };
          "music" = {
            id = "Music-spo";
            path = "/home/nyxar/Music/spotify/";
            devices = devices;
          };
          "pfp" = {
            id = "pfp";
            path = "/home/nyxar/Pictures/wallpaper-pfp/pfp/";
            devices = devices;
          };
          "The_Bp" = {
            id = "Bp-ms";
            path = "/home/nyxar/Documents/The-Bp/";
            devices = devices;
          };
          "Configs" = {
            id = "global-config";
            path = "/home/nyxar/Documents/global-Configs/";
            devices = devices;
          };
        };
      };
    };
  };
}
