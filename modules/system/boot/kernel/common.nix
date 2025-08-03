_: {
  boot = {
    # kernelModules = [
    #   "thinkpad-acpi"
    # ];
    kernelParams = [
      #= E/S & Memory
      "quiet"
      "splash"
      "rootflags=noatime" # To prevent some writes to the ssd
      "rootflags=nodiratime" # Similar to noatime but for dir's
      #"pcie_aspm=force"
      #= Stability
      #"acpi_osi=Linux"
      #"acpi_backlight=vendor"
      "mem_sleep_default=deep"
      #= SSD
      "scsi_mod.use_blk_mq=1"
      "libata.force=noncq"
      #= Remove /dev/mem access restrictions(Needed for Upgrade Coreboot/Libreboot).
      "iomem=relaxed"
      #= Vulnerability mitigations
      "mitigations=auto"
      "mmio_stale_data=full"
      "hardened_usercopy=on"
      "kfence.sample_interval=100"
      "pti=on"
      # Testing
      "random.trust_cpu=1"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    kernel.sysctl = {
      "kernel.split_lock_mitigate" = 0; # In some cases, split lock mitigate can slow down performance in some applications and games.
      "vm.swappiness" = 100;
      "vm.vfs_cache_pressure" = 50;
      "vm.dirty_bytes" = 268435456;
      "vm.page-cluster" = 0;
      "vm.dirty_background_bytes" = 67108864;
      "vm.dirty_writeback_centisecs" = 1500;
      "kernel.sysrq" = 16;
      "kernel.core_uses_pid" = 1;
      "kernel.nmi_watchdog" = 0;
      "kernel.kprt_restrickt" = 2;
      "kernel.kexec_load_disabled" = 1;
      "kernel.pid_max" = 4194304;
      "net.ipv4.conf.default.rp_filter" = 1;
      "net.ipv4.conf.*.rp_filter" = 2;
      "net.ipv4.conf.default.accept_source_route" = 0;
      "net.ipv4.conf.*.accept_source_route" = 0;
      "net.ipv4.conf.default.promote_secondaries" = 1;
      "net.ipv4.conf.*.promote_secondaries" = 1;
      "net.core.netdev_max_backlog" = 4096;
      "fs.file-max" = 209752;
      "fs.aio-max-nr" = 1048576;
      "fs.protected_hardlinks" = 1;
      "fs.protected_symlinks" = 1;
      "fs.protected_regular" = 1;
      "fs.protected_fifos" = 1;
      "fs.suid_dumpable" = 2;
    };
    supportedFilesystems = ["ntfs"];
    blacklistedKernelModules = [
      #= Test
      "snd_seq_dummy"
      "rfcomm"
      "bnep"
      "btusb"
      #"mac_hid"
      #"macvlan"
      #"cmac"
      "dm_mod"
      "lpc_ich"
      #= Not used by the system
      "ath3k"
      # "nouveau"
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
    ];
  };
}
