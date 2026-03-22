{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf optionals;
  cfg = config.mars.hardware;
  rootIsBtrfs = config.fileSystems."/".fsType or "" == "btrfs";
in {
  options.mars.hardware = {
    rootSSD = mkEnableOption "SSD/NVMe optimizations for root filesystem";
  };

  config = {
    # BTRFS Auto-Scrub
    services.btrfs.autoScrub = mkIf rootIsBtrfs {
      enable = true;
      interval = "monthly";
      fileSystems = ["/"];
    };

    # TRIM para SSD
    services.fstrim = mkIf cfg.rootSSD {
      enable = true;
      interval = mkIf rootIsBtrfs "monthly";
    };

    # ZRAM
    zramSwap = {
      enable = true;
      priority = 100;
      memoryPercent = 100;
      algorithm = "lz4";
      swapDevices = 1;
      writebackDevice = null;
    };

    environment.systemPackages = with pkgs;
      [
        woeusb-ng
        popsicle
        usbutils
        iotop
        ncdu
        duf
        f3
      ]
      ++ optionals rootIsBtrfs [
        compsize
        btrfs-progs
      ]
      ++ optionals cfg.rootSSD [
        smartmontools
        nvme-cli
      ];

    # UDisks2 & Automount
    services = {
      udisks2.enable = true;
      gvfs.enable = true;
      devmon.enable = mkDefault false;
      smartd = mkIf cfg.rootSSD {
        enable = true;
        autodetect = true;
      };
    };

    programs = {
      gnome-disks.enable = true;
      udevil.enable = mkDefault false;
    };
  };
}
