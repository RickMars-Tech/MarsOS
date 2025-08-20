{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge optionals;
  asus = config.mars.asus;
  think = config.mars.thinkpad;
  gaming = config.mars.gaming;
  radeon = config.mars.graphics.amd;
  intel = config.mars.graphics.intel;
  nvidiaPro = config.mars.graphics.nvidiaPro;
  plymouth = config.boot.plymouth;
in {
  boot = {
    kernelParams =
      [
        #= Remove /dev/mem access restrictions(Needed for Upgrade Coreboot/Libreboot).
        #"iomem=relaxed"
        #= Vulnerability mitigations
        "mitigations=auto"
      ]
      ++ optionals plymouth.enable [
        #= Silent Mode
        "quiet"
        "loglevel=3"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ]
      ++ optionals asus.enable [
        # Asus
        "acpi_backlight="
        "idle=nomwait"
        "acpi_osi=Linux"
      ]
      ++ optionals gaming.enable [
        "tsc=reliable"
        "clocksource=tsc"
        "preempt=full" # https://reddit.com/r/linux_gaming/comments/1g0g7i0/god_of_war_ragnarok_crackling_audio/lr8j475/?context=3#lr8j475
      ]
      ++ optionals radeon.enable [
        "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
        "amdgpu.mcbp=0"
        # Explicitly set amdgpu support in place of radeon
        "radeon.cik_support=0"
        "amdgpu.cik_support=1"
        "radeon.si_support=0"
        "amdgpu.si_support=1"
        "amdgpu.dc=1" # Enable Display Core for better display support
        "amdgpu.dpm=1" # Enable Dynamic Power Management
      ]
      ++ optionals nvidiaPro.enable [
        "nvidia-drm.modeset=1" # Improve Wayland compatibility
        "nvidia,NVreg_EnableBacklightHandler=1"
        "nvidia.NVreg_UsePageAttributeTable=1"
        "nvidia.NVreg_RegistryDwords=RmEnableAggressiveVblank=1"
      ]
      ++ optionals (nvidiaPro.enable && !nvidiaPro.prime.enable) [
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Have Problems with Prime Offload
      ]
      ++ optionals intel.enable [
        "i915.enable_guc=2" # Carga GuC/HuC (mejora rendimiento/eficiencia)
        "i915.preempt_timeout=100"
        "i915.timeslice_duration=1"
      ]
      ++ optionals (intel.generation == "arc" || intel.generation == "xe") [
        "i915.force_probe=*"
        # "i915.enable_dc=2"
      ];
    kernelModules =
      [
        "ntsync"
      ]
      ++ optionals asus.enable [
        "asus-wmi"
      ]
      # Load Kernel Modules only is needed when nVidia GPU its the Only One,
      # With Prime Offload its not needed
      ++ optionals (nvidiaPro.enable && !nvidiaPro.prime.enable) [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ]
      ++ optionals (nvidiaPro.enable && nvidiaPro.prime.enable) [
        "nvidia_wmi_ec_backlight"
      ]
      ++ optionals think.enable [
        "thinkpad-acpi"
      ];
    kernel.sysctl = mkMerge [
      {
        # https://wiki.archlinux.org/title/Sysctl#Increase_the_memory_dedicated_to_the_network_interfaces
        "net.core.rmem_defaul" = 262144; # 256KB
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
    supportedFilesystems = ["ntfs"];
    blacklistedKernelModules =
      [
        #= Test
        "snd_seq_dummy"
        "rfcomm"
        "bnep"
        "btusb"
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
      ]
      ++ optionals nvidiaPro.enable [
        "nouveau" # set Nvidia Pro Driver support in place of nouveau
      ]
      ++ optionals radeon.enable [
        "radeon" # set amdgpu support in place of radeon
      ];
  };
}
