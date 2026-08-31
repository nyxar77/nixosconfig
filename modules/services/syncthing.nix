{
  config,
  lib,
  ...
}:
lib.mkIf config.nyx.services.syncthing.enable {
  services = {
    syncthing = {
      enable = true;
      user = "nyxar";
      dataDir = "/home/nyxar";
      configDir = "/home/nyxar/.config/syncthing";
      openDefaultPorts = true;
      guiPasswordFile = config.sops.secrets.syncthing-gui-password.path;

      settings = {
        gui = {
          user = "nyxar";
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
            inherit devices;
          };
          "music" = {
            id = "Music-spo";
            path = "${userDir}/Music/spotify/";
            inherit devices;
          };
          "pfp" = {
            id = "pfp";
            path = "${userDir}/Pictures/Images/pfp";
            inherit devices;
          };
          "The_Bp" = {
            id = "Bp-ms";
            path = "${userDir}/Documents/syncthing/The-Bp/";
            inherit devices;
          };
          "Configs" = {
            id = "global-config";
            path = "${userDir}/Documents/syncthing/global-Configs/";
            inherit devices;
          };
          "Twitter" = {
            id = "Twitter-sync";
            path = "${userDir}/Documents/syncthing/Twitter/";
            inherit devices;
          };
          "books" = {
            id = "books-sync";
            path = "${userDir}/Documents/syncthing/books";
          };
          "Notes" = {
            id = "Notes-sync";
            path = "${userDir}/Documents/Notes";
          };
        };
      };
    };
  };
}
