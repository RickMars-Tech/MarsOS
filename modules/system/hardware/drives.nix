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
  #|==< FileSystem >==|#
  # Nota: Con Disko, las opciones de montaje ya están configuradas
  # en disko-config.nix, pero podemos añadir configuraciones adicionales aquí

  # fileSystems = mkMerge [
  #   {
  #     # Tmp Partition - tmpfs en RAM para mejor rendimiento
  #     "/tmp" = {
  #       device = "tmpfs";
  #       fsType = "tmpfs";
  #       options = [
  #         "size=8G" # Aumentado a 8G para compilaciones grandes
  #         "noatime"
  #         "nodev"
  #         "nosuid"
  #         "noexec"
  #         "mode=1777"
  #       ];
  #     };

  #     # /var/tmp - más persistente que /tmp
  #     "/var/tmp" = mkIf (!rootIsBtrfs) {
  #       device = "tmpfs";
  #       fsType = "tmpfs";
  #       options = [
  #         "size=4G"
  #         "noatime"
  #         "nodev"
  #         "nosuid"
  #         "mode=1777"
  #       ];
  #     };
  #   }
  # ];

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
      "(^|/)(init|systemd|Xorg|sway|waybar|kitty|alacritty|foot)$"
      "--prefer"
      "(^|/)(firefox|chromium|chrome|electron|slack|discord|teams|java|node)$"
    ];
  };

  #|==< Swap Configuration >==|#

  # Parámetros de swap optimizados
  boot.kernel.sysctl = {
    # Reduce el uso de swap (prefiere RAM)
    "vm.swappiness" = mkDefault 10;

    # Mejora el rendimiento cuando se usa swap
    "vm.vfs_cache_pressure" = mkDefault 50;

    # Previene OOM matando procesos aleatorios
    "vm.overcommit_memory" = mkDefault 1;

    # Dirty pages - optimiza escritura a disco
    "vm.dirty_ratio" = mkDefault 10;
    "vm.dirty_background_ratio" = mkDefault 5;

    # Para BTRFS específicamente
    "vm.dirty_writeback_centisecs" = mkIf rootIsBtrfs (mkDefault 1500);
  };

  #|==< System Packages >==|#

  environment.systemPackages = with pkgs;
    [
      # Disk management tools
      caligula # TUI para disk imaging
      gnome-disk-utility # GUI disk manager
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

  #|==< Storage Services >==|#
  # UDisks2
  services.udisks2.enable = true;

  # SMART for SSD/NVMe
  services.smartd = mkIf hasSSD {
    enable = true;
    autodetect = true;
    notifications.x11.enable = mkDefault true;
  };
}
