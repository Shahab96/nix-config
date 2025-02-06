{device ? throw "Set this to your disk device, e.g. /dev/sda", ...}: {
  disko.devices = {
    disk = {
      main = {
        inherit device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            esp = {
              name = "ESP";
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              size = "100%";
              content = {
                name = "crypted";
                type = "luks";
                settings = {
                  allowDiscards = true;
                  keyFile = "/tmp/secret.key";
                  crypttabExtraOpts = [
                    "fido2-device=auto"
                    "token-timeout=10"
                  ];
                };
                content = {
                  type = "lvm_pv";
                  vg = "luks_vg";
                };
              };
            };
          };
        };
      };
    };
  };
  lvm_vg = {
    luks_vg = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = "64G";
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };
        root = {
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = ["-L" "nixos" "-f"];
            subvolumes = {
              "/root" = {
                mountpoint = "/";
              };
              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "subvol=nix"
                  "compress=zstd"
                  "noatime"
                ];
              };
              "/persistant" = {
                mountpoint = "/persistant";
                mountOptions = [
                  "subvol=persistant"
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
