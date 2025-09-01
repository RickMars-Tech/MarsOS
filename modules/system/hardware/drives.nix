{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault mkMerge optionals;
  #= Detect if Root is BTRFS
  rootIsBtrfs = config.fileSystems."/".fsType or "" == "btrfs";

  #= Detect if is SDD
  hasSSD =
    builtins.pathExists /sys/block
    && builtins.any (dev:
      builtins.pathExists "/sys/block/${dev}/queue/rotational"
      && builtins.readFile "/sys/block/${dev}/queue/rotational" == "0\n")
    (builtins.attrNames (builtins.readDir /sys/block));
in {
  #|==< FileSystem >==|#
  fileSystems = mkMerge [
    {
      #= BTRFS Optimizations
      "/".options = mkIf rootIsBtrfs ([
          "compress=zstd:6"
          "relatime"
          "commit=120"
          "discard=async"
          "space_cache=v2"
        ]
        ++ (
          if hasSSD
          then [
            "ssd"
          ]
          else [
            "autodefrag"
          ]
        ));
      #= Tmp Partition
      "/tmp" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "size=4G"
          "noatime"
          "noexec"
          "mode=1777"
        ];
      };
    }
  ];
  # Enable AutoScrub if Root Filesystem is BTRFS
  services.btrfs.autoScrub = {
    enable = mkIf rootIsBtrfs true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  #= Enable Trim (Needed for SSD's).
  services.fstrim = {
    enable = mkDefault true;
    interval = mkIf rootIsBtrfs "monthly"; # Less frecuent on BTRFS by discard=async
  };

  #= ZRAM
  # Compression for RAM
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 75;
    algorithm = "zstd";
    swapDevices = 1;
  };

  #= kernel Same-Page Merging
  # Deduplication of identical memory pages
  hardware.ksm = {
    enable = mkDefault true;
    sleep = mkDefault 20;
  };

  #= Prevents system freezes due to lack of memory
  services.earlyoom = {
    enable = mkDefault true;
    freeMemThreshold = 4; # Kill processes when less than 4% RAM and 10% swap remain
    freeSwapThreshold = 10;
    extraArgs = [
      "-g"
      "--avoid"
      "(^|/)(init|kthreadd|ksoftirqd|migration|rcu_|watchdog)$"
      "--prefer"
      "(^|/)(Web Content|Isolated Web|firefox|chromium|chrome)$"
    ];
  };

  environment.systemPackages = with pkgs;
    [
      caligula # User-friendly, lightweight TUI for disk imaging
      gnome-disk-utility # Disk Manager.
      baobab # Gui app to analyse disk usage.
      woeusb # Flash OS images for Windows.
    ]
    ++ optionals rootIsBtrfs [
      compsize
      btrfs-progs
    ]
    ++ optionals hasSSD [
      hdparm
      smartmontools
    ];

  #= Allows Applications to query and manipulate Storage Devices
  services.udisks2.enable = true;
}
