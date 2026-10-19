{
  flake.modules.nixos.drives =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkIf optionals;
      rootIsBtrfs = config.fileSystems."/".fsType or "" == "btrfs";
    in
    {
      services = {

        btrfs.autoScrub = mkIf rootIsBtrfs {
          enable = true;
          interval = "monthly";
          fileSystems = [ "/" ];
        };

        # TRIM 4 SSD
        fstrim = {
          enable = true;
          interval = mkIf rootIsBtrfs "monthly";
        };
      };

      # ZRAM
      # memoryPercent es POR DISPOSITIVO. Con swapDevices=2 y
      # memoryPercent=25 el total era el 50% de la RAM repartido en dos
      # discos, con peor compresión (lz4). Un solo dispositivo con zstd
      # (comprime ~3x) da más swap efectivo gastando menos RAM.
      zramSwap = {
        enable = true;
        priority = 100; # Mayor que el swap en disco: se usa primero
        memoryPercent = 50; # ~3.4GB sin comprimir -> ~1GB reales con zstd
        algorithm = "zstd";
        swapDevices = 1;
      };

      # Swap de disco: último recurso. Ya no hay hibernación configurada,
      # así que 16GB solo servían para thrashing. 4GB de colchón bastan.
      swapDevices = [
        {
          device = "/swapfile";
          size = 4 * 1024;
          priority = 10;
        }
      ];

      # Mata el proceso que más memoria consume antes de que el sistema
      # se congele por presión de memoria (red de seguridad extra a oomd).
      services.earlyoom = {
        enable = true;
        freeMemThreshold = 8;
        freeSwapThreshold = 8;
      };

      environment.systemPackages =
        with pkgs;
        [
          woeusb-ng
          popsicle
          usbutils
          f3
        ]
        ++ optionals rootIsBtrfs [ btrfs-progs ];

      # Disable fsck when BTRFS is used
      # https://wiki.archlinux.org/title/Improving_performance/Boot_process#Filesystem_mounts
      systemd.services.systemd-remount-fs =
        if (!rootIsBtrfs) then
          {
            enable = true;
          }
        else
          {
            enable = false;
          };

      boot.kernelParams = if (!rootIsBtrfs) then [ ] else [ "fsck.mode=skip" ];
    };
}
