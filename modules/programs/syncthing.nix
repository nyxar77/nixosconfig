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
          "oppo4" = {
            id = "IHPGP3S-ZXAP3BG-QHSTLJ6-YEI4ZWE-HE4YX3H-Z2E3ZGG-BQD6F2H-UYR4PQP";
          };
          "oppo8" = {
            id = "CW7QULU-4C4KCKH-ZOPCZK6-7WYI3WS-26BGYWF-UZHY5PA-UJYACHG-UNXHOQU";
          };
        };
        folders = let
          userDir = "/home/nyxar";
          devices = [
            "oppo4"
            "oppo8"
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
