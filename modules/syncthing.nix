{ config, ... }:
{
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
          "oppo" = {
            id = "IHPGP3S-ZXAP3BG-QHSTLJ6-YEI4ZWE-HE4YX3H-Z2E3ZGG-BQD6F2H-UYR4PQP";
          };
        };
        folders =
          let
            userDir = "/home/nyxar";
          in
          {
            "keepass" = {
              id = "xkarx-qj2wy";
              path = "${userDir}/Documents/KeePass/Group1/";
              devices = [
                "oppo"
              ];
            };
            "music" = {
              id = "Music-spo";
              path = "/home/nyxar/Music/spotify/";
              devices = [
                "oppo"
              ];
            };
            "pfp" = {
              id = "pfp";
              path = "/home/nyxar/Pictures/wallpaper-pfp/pfp/";
              devices = [
                "oppo"
              ];
            };
            "The_Bp" = {
              id = "Bp-ms";
              path = "/home/nyxar/Documents/The-Bp/";
              devices = [
                "oppo"
              ];
            };
            "Configs" = {
              id = "global-config";
              path = "/home/nyxar/Documents/global-Configs/";
              devices = [
                "oppo"
              ];
            };
          };
      };
    };
  };
}
