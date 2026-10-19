{
  flake.modules.nixos.gaming-optimizations =
    {
      config,
      lib,
      ...
    }:
    {
      # https://github.com/WhitePeace36/LinuxAMDGamingOptimizationGuide#kernel-commandline-parameter
      boot = {
        kernelParams = [
          "preempt=full"
          "threadirqs"
          "snd_hda_intel.power_save=0"
          "tsc=reliable"
          "clocksource=tsc"
          "split_lock_detect=off"
          "split_lock_mitigate=0"
          "rd.systemd.show_status=false"
          "usbhid.quirks=0x057e:0x2009:0x80000000" # Fix for Switch Pro Controller
        ];
        kernelModules = [
          "ntsync" # Emulates windows synchronization primitives
          "uinput" # User input module for virtual devices
          "snd-seq" # For MIDI support in games
          "snd-rawmidi" # For raw MIDI support
          "hid_nintendo" # Nintendo Switch Pro Controller and Joy-Cons support
        ];
        # https://github.com/WhitePeace36/LinuxAMDGamingOptimizationGuide#kernel-commandline-parameter
        # Ajustes pensados para 8GB de RAM.
        # Se eliminaron valores de guías de gaming de gama alta
        # (watermark_scale_factor=500, compaction_proactiveness=40,
        # threads-max=~1e9, overcommit_memory=1) que en poca RAM causan
        # reclaim agresivo, thrashing y bloqueos por OOM.
        kernel.sysctl = {
          # --- Swap / ZRAM ---
          "vm.swappiness" = lib.mkIf config.zramSwap.enable 100; # 180 provocaba thrashing hacia disco
          "vm.page-cluster" = 0; # Una sola página por lectura de swap (ideal para zram/SSD)
          "vm.zone_reclaim_mode" = 0; # Correcto para escritorio
          "vm.vfs_cache_pressure" = 50;
          "vm.stat_interval" = 10;
          "vm.unprivileged_userfaultfd" = 1; # Requerido por algunos juegos/Wine
          "vm.max_map_count" = 1048576; # Suficiente para juegos; antes ~2^31

          # --- Writeback: evita congelamientos de IO ---
          "vm.dirty_bytes" = 268435456; # 256MB (antes 512MB, demasiado para 8GB)
          "vm.dirty_background_bytes" = 33554432; # 32MB
          "vm.dirty_writeback_centisecs" = 60;

          # --- Memoria / procesos: valores seguros ---
          "vm.overcommit_memory" = 0; # Heurística: falla asignaciones imposibles en vez de colgar con OOM
          "vm.page_lock_unfairness" = 3;
          "vm.defrag_mode" = 0;

          # --- Split lock (coincide con el cmdline) ---
          "kernel.split_lock_mitigate" = 0;

          # --- Watchdog / printk ---
          "kernel.nmi_watchdog" = 0;
          "kernel.printk_devkmsg" = "off";
          "kernel.printk" = "3 3 2 3";
          "kernel.kptr_restrict" = 1;

          # --- Red (rendimiento) ---
          "net.core.busy_read" = 0;
          "net.ipv4.tcp_mtu_probing" = 1;
          "net.ipv4.tcp_congestion_control" = "bbr";
          "net.core.netdev_max_backlog" = 16384;
          "net.core.rmem_max" = 16777216;
          "net.core.wmem_max" = 16777216;
          "net.core.rmem_default" = 8388608;
          "net.core.wmem_default" = 8388608;
        };
      };

      # Udev rules for ntsync
      services.udev.extraRules = ''
        KERNEL=="ntsync", MODE="0660", TAG+="uaccess"
      '';

      environment.etc."drirc".text = ''
        <driconf>
           <device>
               <application name=" Default ">
                   <option name=" vblank_mode" value="0" />
               </application>
           </device>
        </driconf>
      '';

    };
}
