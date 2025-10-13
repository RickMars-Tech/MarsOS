{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge optionals;
  gaming = config.mars.gaming;
  plymouth = config.boot.plymouth;
in {
  boot = {
    supportedFilesystems = ["ntfs"];
    kernelParams =
      [
        #= Remove /dev/mem access restrictions(Needed for Upgrade Coreboot/Libreboot).
        #"iomem=relaxed"
        #= Vulnerability mitigations
        "pcie_aspm=off"
        "mitigations=auto"
      ]
      ++ optionals plymouth.enable [
        #= Silent Mode
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
        "rd.udev.log_priority=3"
      ]
      #= Gaming
      ++ optionals gaming.enable [
        "tsc=reliable"
        "clocksource=tsc"
        "preempt=full" # https://reddit.com/r/linux_gaming/comments/1g0g7i0/god_of_war_ragnarok_crackling_audio/lr8j475/?context=3#lr8j475
      ];

    kernelModules = ["ntsync"];

    kernel.sysctl = mkMerge [
      {
        # https://wiki.archlinux.org/title/Sysctl#Increase_the_memory_dedicated_to_the_network_interfaces
        "net.core.rmem_default" = 262144; # 256KB
        "net.core.rmem_max" = 2097152; # 2MB
        "net.core.wmem_default" = 262144;
        "net.core.wmem_max" = 2097152;
        "net.core.optmem_max" = 20480;
        "net.core.netdev_max_backlog" = 1000;
        "net.ipv4.tcp_rmem" = "4096 262144 4194304";
        "net.ipv4.tcp_wmem" = "4096 262144 4194304";
        "net.ipv4.tcp_congestion_control" = "bbr";
        # https://wiki.archlinux.org/title/Sysctl#Enable_TCP_Fast_Open
        "net.ipv4.tcp_fastopen" = 3;
      }
      (mkIf (gaming.enable && gaming.gamemode.enable)
        {
          "vm.mmap_min_addr" = 0;
          # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/sysctl.d/99-cachyos-settings.conf
          "fs.file-max" = 209752;
          "kernel.split_lock_mitigate" = 0;
          "net.ipv4.tcp_fin_timeout" = 5;
          "vm.dirty_writeback_centisecs" = 1500;
          "vm.page-cluster" = 0;
          # https://wiki.archlinux.org/title/Gaming#Make_the_changes_permanent
          "vm.compaction_proactiveness" = 0;
          "vm.watermark_boost_factor" = 1;
          # "vm.min_free_kbytes" = 262144; # 256MB
          "vm.watermark_scale_factor" = 250;
          "vm.swappiness" = 30;
          "vm.zone_reclaim_mode" = 0;

          "kernel.sched_child_runs_first" = 0;
          "kernel.sched_autogroup_enabled" = 1;
          # Evita que el sistema se bloquee bajo alta carga
          "vm.overcommit_memory" = 0;
          "vm.oom-kill" = 1; # Activa el OOM killer (necesario)

          # https://wiki.archlinux.org/title/Sysctl#Virtual_memory
          "vm.dirty_ratio" = 10;
          "vm.dirty_background_ratio" = 5;
          # VFS cache
          "vm.vfs_cache_pressure" = 20;
        })
    ];
    blacklistedKernelModules = [
      #= Test
      "snd_seq_dummy"
      # "rfcomm"
      # "bnep"
      # "btusb"
      "dm_mod"
      "lpc_ich"
      #= Not used by the system
      "ath3k"
      "fprint"
      "ide_core"
      #= Obscure network protocols
      "af_802154"
      "decnet"
      "econet"
      "ipx"
      "p8022"
      "p8023"
      "psnap"
      "sctp"
      #= Old, rare, or insufficiently audited filesystems
      "f2fs"
      "bcachefs"
      "hfs"
      "hfsplus"
      "jfs"
      "squashfs"
      "udf"
      "ufs"
      #= Unused network filesystems
      "cifs"
      "gfs2"
      "ksmbd"
      "nfs"
      "nfsv3"
      "nfsv4"
      #= Thunderbolt
      "thunderbolt"
      #= Vivid testing driver
      "vivid"
      #= Modules that are disabled in hardened but not the default kernel
      "hwpoison_inject"
      "punit_atom_debug"
      "acpi_configfs"
      "slram"
      "phram"
      "floppy"
      "cpuid"
      "evbug"
    ];
  };
}
