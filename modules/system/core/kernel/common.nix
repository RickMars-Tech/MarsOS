{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf optionals;
  asus = config.mars.asus;
  think = config.mars.thinkpad;
  gaming = config.mars.gaming;
  radeon = config.mars.graphics.amd;
  intel = config.mars.graphics.intel;
  nvidiaPro = config.mars.graphics.nvidiaPro;
in {
  boot = {
    kernelParams =
      [
        #= Remove /dev/mem access restrictions(Needed for Upgrade Coreboot/Libreboot).
        "iomem=relaxed"
        #= Vulnerability mitigations
        "mitigations=auto"
      ]
      ++ optionals asus.enable [
        # Asus
        "acpi_backlight=native"
        "idle=nomwait"
        "acpi_osi=!"
      ]
      ++ optionals gaming.enable [
        "tsc=reliable"
        "clocksource=tsc"
        "mitigations=off"
        "preempt=full" # https://reddit.com/r/linux_gaming/comments/1g0g7i0/god_of_war_ragnarok_crackling_audio/lr8j475/?context=3#lr8j475
        "split_lock_detect=off"
      ]
      ++ optionals radeon.enable [
        "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
        "amdgpu.mcbp=0"
        # # Explicitly set amdgpu support in place of radeon
        "radeon.cik_support=0"
        "amdgpu.cik_support=1"
        "radeon.si_support=0"
        "amdgpu.si_support=1"
        "amdgpu.dc=1" # Enable Display Core for better display support
        "amdgpu.dpm=1" # Enable Dynamic Power Management
      ]
      ++ optionals nvidiaPro.enable [
        "nvidia-drm.modeset=1" # Improve Wayland compatibility
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Preserve VRAM on suspend
      ]
      ++ optionals intel.enable [
        "i915.enable_guc=2" # Carga GuC/HuC (mejora rendimiento/eficiencia)
        "i915.preempt_timeout=100"
        "i915.timeslice_duration=1"
      ]
      ++ optionals (intel.generation == "arc" || intel.generation == "xe") [
        "i915.force_probe=*"
        "i915.enable_dc=2"
      ];
    kernelModules =
      [
        "ntsync"
      ]
      ++ optionals asus.enable [
        "asus_wmi"
      ]
      ++ optionals think.enable [
        "thinkpad-acpi"
      ];
    kernel.sysctl = mkIf (gaming.enable && gaming.gamemode.enable) {
      "vm.max_map_count" = 2147483642;
      "vm.mmap_min_addr" = 0; # SheepShaver
      # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/sysctl.d/99-cachyos-settings.conf
      "fs.file-max" = 2097152;
      "kernel.split_lock_mitigate" = 0;
      "net.ipv4.tcp_fin_timeout" = 5;
      "vm.dirty_background_bytes" = 67108864;
      "vm.dirty_bytes" = 268435456;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.page-cluster" = 0;

      # Memoria: bajo swappiness y cache pressure para priorizar RAM
      "vm.swappiness" = 1;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_ratio" = 15;
      "vm.dirty_background_ratio" = 5;

      # Planificador: tiempo completo para RT y baja migración
      "kernel.sched_rt_runtime_us" = -1; # Sin límite a tareas en tiempo real
      "kernel.sched_migration_cost_ns" = "5000000"; # Reduce migración de tareas

      # Red: optimizado para baja latencia (BBR + buffers altos)
      "net.core.rmem_max" = 536870912;
      "net.core.wmem_max" = 536870912;
      "net.core.netdev_max_backlog" = 5000;
      "net.ipv4.tcp_rmem" = "4096 87380 536870912";
      "net.ipv4.tcp_wmem" = "4096 65536 536870912";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
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
        "nouveau" # set Nvidia Pro Driver support in place of noveau
      ]
      ++ optionals radeon.enable [
        "radeon" # set amdgpu support in place of radeon
      ];
  };
}
