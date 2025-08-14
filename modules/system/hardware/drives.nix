{
  config,
  lib,
  ...
}: let
  inherit (lib) any mkIf mkDefault attrValues;
  # Convertir config.fileSystems (un conjunto) en una lista de sus valores
  fileSystemsList = attrValues config.fileSystems;
  # Verificar si algún sistema de archivos es BTRFS
  hasBtrfs = any (fs: fs.fsType == "btrfs") fileSystemsList;
in {
  # Habilitar autoScrub solo si hay al menos un sistema de archivos BTRFS
  services.btrfs.autoScrub = {
    enable = mkIf hasBtrfs true;
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
    enable = mkDefault true;
    interval = "weekly";
  };

  #= ZRAM.
  zramSwap = {
    enable = true;
    priority = 10;
    memoryPercent = 50;
    algorithm = "zstd";
    swapDevices = 1;
  };

  #= Allows Applications to query and manipulate Storage Devices
  services.udisks2.enable = true;
}
