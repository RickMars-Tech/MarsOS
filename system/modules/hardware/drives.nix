{
  config,
  lib,
  ...
}: let
  # Convertir config.fileSystems (un conjunto) en una lista de sus valores
  fileSystemsList = lib.attrValues config.fileSystems;
  # Verificar si algún sistema de archivos es BTRFS
  hasBtrfs = lib.any (fs: fs.fsType == "btrfs") fileSystemsList;
in {
  # Habilitar autoScrub solo si hay al menos un sistema de archivos BTRFS
  services.btrfs.autoScrub = {
    enable = lib.mkIf hasBtrfs true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  #= Tmp Partition
  fileSystems."/tmp" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = ["size=4G"]; # Use 8G if you have 32GB of ram or more.
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
