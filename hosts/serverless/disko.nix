{
  disko.devices = {
    disk.main = {
      type = "disk";
      # disko-install overrides this with: --disk main /dev/disk/by-id/...
      device = "/dev/disk/by-id/SET-ME-SERVERLESS";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
              mountOptions = [ "umask=0077" ];
            };
          };

          lvm = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "serverless";
            };
          };
        };
      };
    };

    lvm_vg.serverless = {
      type = "lvm_vg";
      lvs = {
        root = {
          size = "40G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            extraArgs = [
              "-m"
              "1"
            ];
          };
        };

        nix = {
          size = "90G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/nix";
            mountOptions = [ "noatime" ];
            extraArgs = [
              "-m"
              "0"
            ];
          };
        };

        home = {
          size = "20G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/home";
            extraArgs = [
              "-m"
              "0"
            ];
          };
        };

        services = {
          size = "250G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/srv";
            extraArgs = [
              "-m"
              "0"
            ];
          };
        };

        swap = {
          size = "12G";
          content.type = "swap";
        };
      };
    };
  };
}
