{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  # Verificar específicamente si el sistema root (/) usa BTRFS
  rootIsBtrfs = config.fileSystems."/".fsType or "" == "btrfs";
in {
  #|==< FileSystem >==|#
  fileSystems = {
    #= BTRFS Optimizations
    "/".options = mkIf rootIsBtrfs [
      "ssd"
      "compress=zstd:3"
      "commit=120"
      "noatime"
      "discard=async"
      "space_cache=v2"
    ];
    #= Tmp Partition
    "/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = ["size=3G" "noatime" "mode=1777"]; # Use 8G if you have 32GB of ram or more.
    };
  };
  # Enable AutoScrub if Root Filesystem is BTRFS
  services.btrfs.autoScrub = {
    enable = mkIf rootIsBtrfs true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  #= Enable Trim (Needed for SSD's).
  services.fstrim = mkIf (!rootIsBtrfs) {
    enable = mkDefault true;
    interval = "weekly";
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
    sleep = mkDefault 20; # Run every 20 seconds (balance between CPU and memory)
  };

  #= Prevents system freezes due to lack of memory
  services.earlyoom = {
    enable = mkDefault true;
    freeMemThreshold = 4; # Kill processes when less than 4% RAM and 10% swap remain
    freeSwapThreshold = 10;
    # Avoid killing important system processes
    extraArgs = [
      "-g"
      "--avoid '(^|/)(init|kthreadd|ksoftirqd|migration|rcu_|watchdog)'"
      "--prefer '(^|/)(Web Content|Isolated Web|firefox|chromium|chrome)'"
    ];
  };

  #= Allows Applications to query and manipulate Storage Devices
  services.udisks2.enable = true;
}
