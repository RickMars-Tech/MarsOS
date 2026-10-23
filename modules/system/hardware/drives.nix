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
      zramSwap = {
        enable = true;
        priority = 100; # Mayor que el swap en disco: se usa primero
        memoryPercent = 75;
        algorithm = "zstd";
        swapDevices = 1;
      };

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
