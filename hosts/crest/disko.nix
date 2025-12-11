{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              priority = 1;
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            swap = {
              priority = 2;
              size = "4G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              priority = 3;
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f" "-L" "nixos"];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd:3" # Nivel 3 es mejor balance
                      "noatime" # Mejor que relatime para SSDs
                      "discard=async"
                      "space_cache=v2"
                      "ssd"
                    ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd:3"
                      "noatime"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd:1"
                      "noatime"
                      "space_cache=v2"
                      "ssd"
                    ];
                  };
                  # Subvolumen para snapshots (opcional pero recomendado)
                  "/.snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = [
                      "compress=zstd:3"
                      "noatime"
                    ];
                  };
                  # Subvolumen para logs (opcional)
                  "/var/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [
                      "compress=zstd:1"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=4G"
          "mode=1777"
        ];
      };
    };
  };
}
