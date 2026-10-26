let 
  zpoolName = "laptop-rpool"; # Change to desired pool name
  swapSize = "38"; # Change to your desired swap size in Gib
in {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-diskseq/1"; # Change to desired disk if you dont want it to grab the first disk
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "nofail" ];
              };
            };
            encryptedSwap = {
              size = "${swapSize}G";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100; # prefer to encrypt as long as we have space for it
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = zpoolName; 
              };
            };
          };
        };
      };
    };
    zpool = {
      ${zpoolName} = {
        type = "zpool"; 
        rootFsOptions = {
          mountpoint = "none";
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        options.ashift = "12";

        datasets = {
          "roots" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "roots/nixos" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "roots/nixos/empty" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
            postCreateHook = "zfs snapshot ${zpoolName}/roots/nixos/empty@start";
          };
          "roots/nixos/var" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "roots/nixos/var/log" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/var/log";
            options."com.sun:auto-snapshot" = "true";
          };
          "roots/nixos/var/lib" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/var/lib";
            options."com.sun:auto-snapshot" = "true";
          };
          "roots/nixos/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options."com.sun:auto-snapshot" = "false";
          };
          "roots/nixos/config" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/etc/nixos";
            options."com.sun:auto-snapshot" = "true";
          };

          "local/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
              "com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
    };
  };
}