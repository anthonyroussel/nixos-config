{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "pool";
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          home = {
            size = "512M";
            content = {
              type = "btrfs";
              mountpoint = "/home";
              extraArgs = [
                "-L"
                "home"
              ];
              subvolumes = {
                "/aroussel" = {
                  mountpoint = "/home/aroussel";
                };
              };
            };
          };
          nixos = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
              extraArgs = [
                "-L"
                "nixos"
              ];
              subvolumes = {
                "/nix" = {
                  mountOptions = [ "noatime" ];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };
}
