{ config, ... }: {
    
    boot = {
        kernelModules = [
            "tp_smapi"
        ];
        # Security kernel parameters from:
        # - https://madaidans-insecurities.github.io/guides/linux-hardening.html
        # - https://github.com/secureblue/secureblue/blob/live/config/files/usr/share/ublue-os/just/60-custom.just.readme.md
        # - https://tails.net/contribute/design/kernel_hardening/
        # - https://github.com/a13xp0p0v/kernel-hardening-checker/
        kernelParams = [
        ## Kernel self-protection
        # Hide kernel log during boot
            "quiet"
        # Enable IOMMU
            "iommu=force"
            #"amd_iommu=force_isolation"
        # Randomize page allocator freelists
            "page_alloc.shuffle=1"
        # CPU vulnerability mitigations
            "mitigations=auto"
            "cfi=kcfi"
            "hardened_usercopy=on"
            "kfence.sample_interval=100"
            "pti=on"
        # GPU
            "i915.enable_rc6=7"
        ## Reduce attack surface
        # Disable debugfs
            "debugfs=off"
        ];

        # Security sysctl settings variously collected from:
        # - https://madaidans-insecurities.github.io/guides/linux-hardening.html
        # - https://github.com/secureblue/secureblue/blob/live/config/files/usr/etc/sysctl.d/hardening.conf
        # - https://github.com/a13xp0p0v/kernel-hardening-checker/
        # - the Arch Wiki, including:
            # - https://wiki.archlinux.org/title/Security
            # - https://wiki.archlinux.org/title/Sysctl
            # - https://wiki.archlinux.org/title/Core_dump
        kernel.sysctl = {
        ## T420
        # Disable NMI Watchdog
            "kernel.nmi_watchdog" = 0;
        # Enable ipv4 forwarding for virtual machines
            "net.ipv4.ip_forward" = 1;
        # Laptop tweaks
            "vm.vfs_cache_pressure" = 50;
            "vm.laptop_mode" = 5;
            "vm.swappiness" = 1;
            "vm.dirty_writeback_centisecs" = 1500;
        ## Kernel self-protection
        # Mitigate kernel pointer leaks
            "kernel.kptr_restrict" = 2;
        # Hide kernel log during boot
            "kernel.printk" = "3 3 3 3";
        # Harden BPF
            "kernel.unprivileged_bpf_disabled" = 1;
            "net.core.bpf_jit_harden" = 2;
        # Restrict usage of performace events to CAP_PERFMON
            "kernel.perf_event_paranoid" = 3;
            "kernel.oops_limit" = 100;
            "kernel.warn_limit" = 100;
        ## Network
        # Help pretect against syn floods
            "net.ipv4.tcp_syncookies" = 1;
        # Do source validation of packets
            "net.ipv4.conf.all.rp_filter" = 1;
            "net.ipv4.conf.default.rp_filter" = 1;
        # Disable ICMP redirects
            "net.ipv4.conf.all.accept_redirects" = 0;
            "net.ipv4.conf.default.accept_redirects" = 0;
            "net.ipv4.conf.all.secure_redirects" = 0;
            "net.ipv4.conf.default.secure_redirects" = 0;
            "net.ipv6.conf.all.accept_redirects" = 0;
            "net.ipv6.conf.default.accept_redirects" = 0;
            "net.ipv4.conf.all.send_redirects" = 0;
            "net.ipv4.conf.default.send_redirects" = 0;
        # Ignore ICMP requests
            "net.ipv4.icmp_echo_ignore_all" = 1;
            "net.ipv6.icmp.echo_ignore_all" = 1;
        # Disable source routing
            "net.ipv4.conf.all.accept_source_route" = 0;
            "net.ipv4.conf.default.accept_source_route" = 0;
            "net.ipv6.conf.all.accept_source_route" = 0;
            "net.ipv6.conf.default.accept_source_route" = 0;
        # Disable IPv6 router advertisements
            "net.ipv6.conf.all.accept_ra" = 0;
            "net.ipv6.conf.default.accept_ra" = 0;
        # Log Martian packets
            "net.ipv4.conf.all.log_martians" = 1;
            "net.ipv4.conf.default.log_martians" = 1;
        ## User space
        # Restrict ptrace scope
            "kernel.yama.ptrace_scope" = 1;
        # Make data spoofing more difficult
            "fs.protected_fifos" = 2;
            "fs.protected_regular" = 2;
        # Prevent suid processes from dumping core
            "fs.suid_dumpable" = 0;
            "fs.protected_symlinks" = 1;
            "fs.protected_hardlinks" = 1;
        };

        # - https://madaidans-insecurities.github.io/guides/linux-hardening.html
        # - https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
        blacklistedKernelModules = [
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
            "ksmbd"
            "nfs"
            "nfsv3"
            "nfsv4"
        # Vivid testing driver
            "vivid"
        ];

        extraModulePackages = with config.boot.kernelPackages; [ tp_smapi ];

        extraModprobeConfig = "
            options snd_hda_intel power_save=1
            options thinkpad_acpi fan_control=1
            options i915 i915_enable_rc6=7 lvds_downclock=1
            options usbcore autosuspend=2
        ";
    };
}

