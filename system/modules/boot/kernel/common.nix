{
  pkgs,
  lib,
  ...
}: {
  boot = {
    kernelModules = [
      "thinkpad-acpi"
      "msr"
      "coretemp"
      "kvm-intel"
      "binder_linux" # Comunicación Android
      #"tp_smapi" <--- Doesn't Work with Coreboot
    ];
    # Security kernel parameters from:
    # - https://madaidans-insecurities.github.io/guides/linux-hardening.html
    # - https://github.com/secureblue/secureblue/blob/live/config/files/usr/share/ublue-os/just/60-custom.just.readme.md
    # - https://tails.net/contribute/design/kernel_hardening/
    # - https://github.com/a13xp0p0v/kernel-hardening-checker/
    kernelParams = [
      ## Readhead profiling
      "profile"
      ## use deadline(for SSD's)
      "elevator=deadline"
      ## Kernel self-protection
      # Randomize page allocator freelists
      #"page_alloc.shuffle=1"
      # CPU vulnerability mitigations
      "mitigations=auto"
      "cfi=kcfi"
      "hardened_usercopy=on"
      "kfence.sample_interval=100"
      "pti=on"
      # Set transparent_hugepage to Always
      "transparent_hugepage=madvise"
      # GPU
      "i915.enable_rc6=1" # Habilitar RC6 para ahorro energético en Intel HD 3000
      "i915.enable_fbc=1" # Framebuffer compression para GPU
      "i915.semaphores=1"
      #"pcie_aspm=force"
      # Enable Intel IOMMU
      "intel_iommu=on"
      # Synchronously invalidate IOMMU hardware TLB
      "iommu.strict=1"
      # Disable IOMMU bypass
      "iommu.passthrough=0"
      # Fix hole in IOMMU
      "efi=disable_early_pci_dma"
      # Remove /dev/mem access restrictions(Needed for Upgrade Coreboot/Libreboot).
      "iomem=relaxed"
      ## Reduce attack surface
      # Disable TSX
      #"tsx=off"
      # Disable vsyscalls
      "vsyscall=none"
      # Disallow writing to mounted block devices
      "bdev_allow_write_mounted=0"
      # Disable debugfs
      "debugfs=off"
    ];

    # Security sysctl settings variously collected from:
    # - https://madaidans-insecurities.github.io/guides/linux-hardening.html
    # - https://github.com/secureblue/secureblue/blob/live/config/files/usr/etc/sysctl.d/hardening.conf
    # - https://github.com/a13xp0p0v/kernel-hardening-checker/
    # - the Arch Wiki, including:
    # - - - https://wiki.archlinux.org/title/Security
    # - - - https://wiki.archlinux.org/title/Sysctl
    # - - - https://wiki.archlinux.org/title/Core_dump
    kernel.sysctl = lib.mkDefault {
      # platformOptimizations
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.ipv4.tcp_fin_timeout" = 5;
      # Enable TCP Fast Open
      "net.ipv4.tcp_fastopen" = 3;
      # VFS Cache, controls the tendency of the kernel to reclaim memory
      "vm.swappiness" = 10;
      "vm.vfs_cache_pressure" = 100;
      "vm.dirty_bytes" = 134217728; # 128 MB
      "vm.dirty_background_bytes" = 33554432; # 32 MB
      "vm.page-cluster" = 3;
      # Disable NMI Watchdog
      "kernel.nmi" = 0;
      # Enable IP Spoofing protection, turn on source route verification
      "net.ipv4.conf.all.rp_filter" = 1;
      "net.ipv4.conf.default.rp_filter" = 1;
      # Disable ICPM Redirect Acceptance
      "net.ipv4.conf.*.send_refirects" = 0;
      "net.ipv4.conf.*.accept_redirects" = 0;
      "net.ipv6.conf.*.accept_redirects" = 0;
      # Ignore ICMP requests
      "net.ipv4.icmp_echo_ignore_all" = 1;
      "net.ipv6.icmp.echo_ignore_all" = 1;
      # Enable IPV6 privacy Extension
      "net.ipv6.conf.all.use_tempaddr" = 2;
      "net.ipv6.conf.default.use_tempaddr" = 2;
      # Enable Log Spoofed Packages, Source Routed Packets, Redirect Packets
      "net.ipv4.conf.all.log_martians" = 1;
      "net.ipv4.conf.default.log_martians" = 1;
      "net.core.bpf_jit_harden" = 2;
      "kernel.yama.ptrace_scope" = 3;
      "kernel.unprivileged_bpf_disabled" = 1;
      "kernel.sysrq" = 0;
      "kernel.perf_event_paranoid" = 3;
      "kernel.kptr_restrict" = 2;
      "kernel.dmesg_restrict" = 1;
      "fs.binfmt_misc.status" = 0;
      "fs.suid_dumpable" = 0;
      "fs.protected_regular" = 2;
      "fs.protected_fifos" = 2;
      "dev.tty.ldisc_autoload" = 0;
      # Restrict Userfaultd to CAP_SYS_PTRACE
      "vm.unprivileged_userfaultfd" = 0;
      ## Prevent Kernel info Leaks in Console During Boot
      ## https://phabricator.whonix.org/T950
      "kernel.printk" = "4 4 1 7";
      ##  Disables kexec wich can be used to replace the running kernel.
      "kernel.kexec_load_disabled" = 1;
      ## Disable core dump
      "kernel.core_pattern" = "|${pkgs.coreutils-full}/bin/false";
      ## Disable io_uring
      ## https://lore.kernel.org/lkml/20230629132711.1712536-1-matteorizzo@google.com/T/
      ## https://security.googleblog.com/2023/06/learnings-from-kctf-vrps-42-linux.html
      "kernel.io_uring_disabled" = 0;
      # Improve ALSR effectiveness for mmap.
      "vm.mmap_rnd_bits" = 32;
      "vm.mmap_rnd_compat_bits" = 16;
      ## Reduce attack surface
      # Disable legacy TIOCSTI
      "dev.tty.legacy_tiocsti" = 0;
    };

    # - https://madaidans-insecurities.github.io/guides/linux-hardening.html
    # - https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
    blacklistedKernelModules = [
      # Not used by the system
      "ath3k"
      "nouveau"
      "fprint"
      "ide_core"
      # Obscure network protocols
      "af_802154"
      "decnet"
      "econet"
      "ipx"
      "p8022"
      "p8023"
      "psnap"
      "sctp"
      # Old, rare, or insufficiently audited filesystems
      "f2fs"
      "hfs"
      "hfsplus"
      "jfs"
      "squashfs"
      "udf"
      "ufs"
      # Unused network filesystems
      "cifs"
      "gfs2"
      "ksmbd"
      "nfs"
      "nfsv3"
      "nfsv4"
      # Firewire and Thunderbolt
      "firewire-core"
      "thunderbolt"
      # Vivid testing driver
      "vivid"
      # Bluetooh
      #"bluetooth"
      #"btusb"
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

    #extraModulePackages = with config.boot.kernelPackages; [ #tp_smapi ]; #<--- Doesn't Work with Coreboot

    extraModprobeConfig = "
    blacklist iTCO_wdt
    options thinkpad_acpi  fan_control=1
      ";
  };
}
