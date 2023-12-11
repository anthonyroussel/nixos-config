{ disks ? [ "/dev/vda" ], ... }:

let
  partitionTypes = {
    efi = "EF00";
  };

in {
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = partitionTypes.efi;
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
                extraOpenArgs = [ ];
                # settings = {
                #   # if you want to use the key for interactive login be sure there is no trailing newline
                #   # for example use `echo -n "password" > /tmp/secret.key`
                #   keyFile = "/tmp/secret.key";
                #   allowDiscards = true;
                # };
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
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/home";
              extraArgs = [ "-L" "home" ];
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
              type = "filesystem";
              format = "btrfs";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
              extraArgs = [ "-L" "nixos" ];
              subvolumes = {
                "/" = { };
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
