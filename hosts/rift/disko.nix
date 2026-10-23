{
  flake.diskoConfigurations.rift = {
    # Your disk configuration starts here:
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/nvme0n1";
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
                  mountOptions = [ "umask=0077" ];
                };
              };
              # Swap en partición (p2), no swapfile: en BTRFS un swapfile activo
              # degrada `scrub`/`balance` (sus block groups se saltan) y el
              # subvolumen que lo contiene no se puede snapshotear. Ocupa el
              # hueco que ya existía entre ESP y root (resto de una swap previa).
              # 4 GB bastan como último recurso: lo principal lo cubre zram.
              swap = {
                priority = 2;
                name = "swap";
                label = "swap";
                size = "4G";
                content = {
                  type = "swap";
                  randomEncryption = false;
                  # prio 10 < zram (100): el swap en disco es el último recurso.
                  priority = 10;
                  discardPolicy = "once";
                };
              };
              root = {
                priority = 3;
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = [
                    "-f"
                    "-L"
                    "nixos"
                  ];
                  subvolumes = {
                    "/root" = {
                      mountpoint = "/";
                      mountOptions = [
                        "compress=zstd:3"
                        "noatime"
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
            "size=2G" # Antes 4G: la mitad de la RAM en tmpfs era excesivo
            "mode=1777"
          ];
        };
      };
    };
  };
}
