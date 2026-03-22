{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge mkDefault optionals;
  gaming = config.mars.gaming;
  plymouth = config.boot.plymouth;
  rootIsBtrfs = config.fileSystems."/".fsType or "" == "btrfs";
in {
  boot = {
    supportedFilesystems = ["ntfs"];
    kernelParams =
      [
        # Vulnerability mitigations
        "pcie_aspm=off"
        "mitigations=auto"
        "randomize_kstack_offset=on" # Randomize kernel stack offset on each syscall (mitigates some exploits)
        "vsyscall=none" # Disable vsyscall (removes legacy syscall interface, improves security)
        "slab_nomerge" # Disable merging of similar SLAB caches (hardens against some heap attacks)
        "module.sig_enforce=1" # Only allow loading kernel modules with valid signatures (prevents unsigned modules)
        "lockdown=confidentiality" # Enable kernel lockdown in confidentiality mode (restricts kernel access even for root)
        "page_poison=1" # Fill freed memory pages with poison value (helps detect use-after-free bugs)
        "page_alloc.shuffle=1" # Randomize page allocator order (mitigates some memory corruption attacks)
        "sysrq_always_enabled=0" # Disable magic SysRq key entirely (prevents low-level system commands)
        "rootflags=noatime" # Mount root filesystem with noatime (improves performance, disables file access time updates)
        "lsm=landlock,lockdown,yama,integrity,apparmor,bpf,tomoyo,selinux" # Enable and order Linux Security Modules (stacked LSMs for security)
        "fbcon=nodefer" # Do not defer kernel messages to framebuffer console (shows messages immediately)
      ]
      ++ optionals plymouth.enable [
        # Silent Mode
        "quiet"
        "splash"
        "nowatchdog"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
        "rd.udev.log_priority=3"
      ]
      # Gaming
      ++ optionals gaming.enable [
        "preempt=full"
        "threadirqs"
        "snd_hda_intel.power_save=0"
        "tsc=reliable"
        "clocksource=tsc"
        "usbhid.quirks=0x057e:0x2009:0x80000000" # Fix for Switch Pro Controller
      ];
    kernelModules =
      [
        "ntsync"
        "tcp_bbr"
        "sch_cake"
      ]
      ++ optionals gaming.enable [
        "uinput" # User input module for virtual devices
        "snd-seq" # For MIDI support in games
        "snd-rawmidi" # For raw MIDI support
        "hid_nintendo" # Nintendo Switch Pro Controller and Joy-Cons support
      ];
    kernel.sysfs.kernel.mm.transparent_hugepage = {
      enabled = "madvise";
      defrag = "defer+madvise";
      shmem_enabled = "never";
      khugepaged.max_ptes_none = 409;
    };

    kernel.sysctl = mkMerge [
      (mkIf rootIsBtrfs {
        "vm.dirty_writeback_centisecs" = mkDefault 3000;
      })
      (mkIf (gaming.enable && gaming.gamemode.enable) {
        "kernel.split_lock_mitigate" = 0;
        "kernel.sched_autogroup_enabled" = 1;
        # The sysctl swappiness parameter determines the kernel's preference for pushing anonymous pages or page cache to disk in memory-starved situations.
        # A low value causes the kernel to prefer freeing up open files (page cache), a high value causes the kernel to try to use swap space,
        # and a value of 100 means IO cost is assumed to be equal.
        "vm.swappiness" = 100;

        # The value controls the tendency of the kernel to reclaim the memory which is used for caching of directory and inode objects (VFS cache).
        # Lowering it from the default value of 100 makes the kernel less inclined to reclaim VFS cache (do not set it to 0, this may produce out-of-memory conditions)
        "vm.vfs_cache_pressure" = 50;

        # Contains, as bytes, the number of pages at which a process which is
        # generating disk writes will itself start writing out dirty data.
        "vm.dirty_bytes" = 268435456;

        # page-cluster controls the number of pages up to which consecutive pages are read in from swap in a single attempt.
        # This is the swap counterpart to page cache readahead. The mentioned consecutivity is not in terms of virtual/physical addresses,
        # but consecutive on swap space - that means they were swapped out together. (Default is 3)
        # increase this value to 1 or 2 if you are using physical swap (1 if ssd, 2 if hdd)
        "vm.page-cluster" = 0;

        # Contains, as bytes, the number of pages at which the background kernel
        # flusher threads will start writing out dirty data.
        "vm.dirty_background_bytes" = 67108864;

        # The kernel flusher threads will periodically wake up and write old data out to disk.  This
        # tunable expresses the interval between those wakeups, in 100'ths of a second (Default is 500).
        "vm.dirty_writeback_centisecs" = 1500;

        # This action will speed up your boot and shutdown, because one less module is loaded. Additionally disabling watchdog timers increases performance and lowers power consumption
        # Disable NMI watchdog
        "kernel.nmi_watchdog" = 0;

        # Enable the sysctl setting kernel.unprivileged_userns_clone to allow normal users to run unprivileged containers.
        "kernel.unprivileged_userns_clone" = 1;

        # To hide any kernel messages from the console
        "kernel.printk" = "3 3 3 3";

        # Restricting access to kernel pointers in the proc filesystem
        "kernel.kptr_restrict" = 2;

        # Increase netdev receive queue
        # May help prevent losing packets
        "net.core.netdev_max_backlog" = 4096;

        # Set size of file handles and inode cache
        "fs.file-max" = 2097152;
      })
    ];

    blacklistedKernelModules = [
      # Test
      "snd_seq_dummy"
      "dm_mod"
      "lpc_ich"
      # Not used by the system
      "ath3k"
      "fprint"
      "ide_core"
      # Obscure network protocols
      "sctp"
      "af_802154" # IEEE 802.15.4
      "appletalk" # Appletalk
      "atm" # ATM
      "ax25" # Amatuer X.25
      "decnet" # DECnet
      "econet" # Econet
      "ipx" # Internetwork Packet Exchange
      "n-hdlc" # High-level Data Link Control
      "netrom" # NetRom
      "p8022" # IEEE 802.3
      "p8023" # Novell raw IEEE 802.3
      "psnap" # SubnetworkAccess Protocol
      "rds" # Reliable Datagram Sockets
      "rose" # ROSE
      "tipc" # Transparent Inter-Process Communication
      "x25" # X.25
      # Old or rare or insufficiently audited filesystems.
      "adfs" # Active Directory Federation Services
      "affs" # Amiga Fast File System
      "befs" # "Be File System"
      "bfs" # BFS, used by SCO UnixWare OS for the /stand slice
      "cramfs" # compressed ROM/RAM file system
      "efs" # Extent File System
      "erofs" # Enhanced Read-Only File System
      "exofs" # EXtended Object File System
      "f2fs" # Flash-Friendly File System
      "freevxfs" # Veritas filesystem driver
      "gfs2" # Global File System 2
      "hfs" # Hierarchical File System (Macintosh)
      "hfsplus" # Same as above, but with extended attributes.
      "hpfs" # High Performance File System (used by OS/2)
      "jffs2" # Journalling Flash File System (v2)
      "jfs" # Journaled File System - only useful for VMWare sessions
      "ksmbd" # SMB3 Kernel Server
      "minix" # minix fs - used by the minix OS
      "nilfs2" # New Implementation of a Log-structured File System
      "omfs" # Optimized MPEG Filesystem
      "qnx4" # Extent-based file system used by the QNX4 OS.
      "qnx6" # Extent-based file system used by the QNX6 OS.
      "squashfs" # compressed read-only file system (used by live CDs)
      "sysv" # implements all of Xenix FS, SystemV/386 FS and Coherent FS.
      "udf" # https://docs.kernel.org/5.15/filesystems/udf.html
      "vivid" # Virtual Video Test Driver (unnecessary)
      # Unused network filesystems
      "cifs"
      "gfs2"
      "ksmbd"
      "nfs"
      "nfsv3"
      "nfsv4"
      # Disable Thunderbolt and FireWire to prevent DMA attacks
      "firewire-core"
      "thunderbolt"
      #= Vivid testing driver
      "vivid"
      #= ALWAYS nouveau should be used instead.
      "nvidiafb"
      # Modules that are disabled in hardened but not the default kernel
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
