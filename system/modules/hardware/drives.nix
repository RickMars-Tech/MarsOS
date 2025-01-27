{ ... }:
{

  #= Tmp Partition
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "size=4G" ]; # Use 8G if you have 32GB of ram or more.
  };

  #= SmartD.
  services.smartd = {
    enable = true;
    autodetect = true;
  };

  #= Enable Trim (Needed for SSD's).
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  #= ZRAM.
  zramSwap = {
    enable = true;
    priority = 10;
    memoryPercent = 50;
    algorithm = "zstd";
    swapDevices = 2;
  };

  #= USB.
  services.gvfs.enable = true;
  services.udisks2.enable = true;

}
