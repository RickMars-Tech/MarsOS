{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault optionals;

  # Detect if Root is BTRFS
  rootIsBtrfs = config.fileSystems."/".fsType or "" == "btrfs";

  # Detect if is SSD
  hasSSD =
    builtins.pathExists /sys/block
    && builtins.any (dev:
      builtins.pathExists "/sys/block/${dev}/queue/rotational"
      && builtins.readFile "/sys/block/${dev}/queue/rotational" == "0\n")
    (builtins.attrNames (builtins.readDir /sys/block));
in {
  # BTRFS Auto-Scrub - verificación de integridad mensual
  services.btrfs.autoScrub = mkIf rootIsBtrfs {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };

  # TRIM para SSD - optimización de rendimiento
  services.fstrim = {
    enable = mkDefault true;
    interval = mkIf rootIsBtrfs "monthly"; # Menos frecuente con discard=async
  };

  #|==< Memory Management >==|#

  # ZRAM - compresión de RAM para mejor uso de memoria
  zramSwap = {
    enable = true;
    priority = 100; # Mayor prioridad que swap de disco
    memoryPercent = 100; # Usa hasta 100% de RAM para ZRAM
    algorithm = "zstd";
    swapDevices = 1;
  };

  # Kernel Same-Page Merging - deduplicación de memoria
  hardware.ksm = {
    enable = mkDefault true;
    sleep = mkDefault 1000; # ms entre escaneos (1000 = menos agresivo)
  };

  # Early OOM - previene congelamiento del sistema
  services.earlyoom = {
    enable = mkDefault true;
    freeMemThreshold = 5; # Activa cuando queda menos del 5% RAM
    freeSwapThreshold = 10; # Y menos del 10% swap
    enableNotifications = true; # Notificaciones cuando mata procesos
    extraArgs = [
      "-g" # Mata todo el grupo de procesos
      "--avoid"
      "(^|/)(init|systemd|wayland|niri|ironbar|wezterm|steam)$"
      "--prefer"
      "(^|/)(firefox|chromium|chrome|electron|slack|discord)$"
    ];
  };

  environment.systemPackages = with pkgs;
    [
      usbutils
      # Disk management tools
      caligula # TUI para disk imaging
      baobab # Análisis de uso de disco
      woeusb # Flash Windows ISO
      gparted # Particionamiento avanzado

      # Monitoring tools
      iotop # Monitor I/O de disco
      ncdu # Análisis de espacio en disco (TUI)
      duf # Mejor 'df' con colores
    ]
    ++ optionals rootIsBtrfs [
      compsize # Ver compresión real de BTRFS
      btrfs-progs # Herramientas BTRFS
      btrbk # Backup automático con snapshots
    ]
    ++ optionals hasSSD [
      hdparm # Configuración de discos
      smartmontools # Monitoreo SMART
      nvme-cli # Herramientas específicas para NVMe
    ];

  #|==< Storage >==|#
  # UDisks2 & Automount Devices
  services = {
    udisks2.enable = true;
    gvfs.enable = true;
    devmon.enable = true;
  };
  # GUI disk manager
  programs.gnome-disks.enable = true;

  # SMART for SSD/NVMe
  services.smartd = mkIf hasSSD {
    enable = true;
    autodetect = true;
    notifications.x11.enable = mkDefault true;
  };
}
