{
  flake.modules.nixos.kernelCommon = {
    boot = {
      supportedFilesystems = [ "ntfs" ];
      kernelParams = [
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
        "libahci.ignore_sss=1"
      ];
      kernelModules = [
        "tcp_bbr"
        "sch_cake"
      ];
      kernel.sysfs.kernel.mm.transparent_hugepage = {
        enabled = "madvise";
        defrag = "defer+madvise";
        shmem_enabled = "never";
        khugepaged.max_ptes_none = 409;
      };

      blacklistedKernelModules = [
        # https://xint.io/blog/copy-fail-linux-distributions#remediation-7
        # "algif_aead"
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
  };
}
