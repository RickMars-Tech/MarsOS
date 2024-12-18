{ config, lib, pkgs, ... }: {

    imports = [ ./common.nix ];

    # See my article to learn how this works step by step:
    # https://liassica.codeberg.page/posts/0004-clang-linux-nixos/
    boot = {
        kernelPackages =
            with pkgs;
            let
                llvm = llvmPackages_latest; # Build fails unless using latest LLVM
                kernel = linux_latest;
            in
            linuxPackagesFor (
            # Compile with Clang/LLVM for features like CFI_CLANG and LTO_CLANG_THIN
            (kernel.override {
                extraMakeFlags = [
                    "LLVM=1"
                    "LLVM_IAS=1"
                ];

                stdenv = overrideCC llvm.stdenv (
                    llvm.stdenv.cc.override {
                    # Use LLVM bintools; LTO_CLANG_THIN requires using `lld` as the linker
                        bintools = llvm.bintools.override {
                        # Boot failure otherwise: https://github.com/NixOS/nixpkgs/issues/242244#issuecomment-1694235345
                           sharedLibraryLoader = null;
                        };
                    }
                );

                    structuredExtraConfig =
                    let
                        inherit (lib)
                            genAttrs
                            listToAttrs
                            mkForce
                            nameValuePair
                            ;
                        y = lib.kernel.yes;
                        n = lib.kernel.no;
                        u = lib.kernel.unset;
                        f = lib.kernel.freeform;
                    in
                    {
                        # CPU Optimizations for Sandy/Ivy Bridge
                        MCORE2 = y;
                        X86_INTEL_PSTATE = y;
                        INTEL_IDLE = y; # Soporte de administración de energía específico de Intel
                        # Intel iGPU
                        DRM_I915 = y;
                        DRM_I915_GVT = y;
                        # Futex WAIT_MULTIPLE Implemetation for Wine/Proton Fsync
                        FUTEX = y;
                        FUTEX_PI = y;
                        # Google's BBRv3 TCP Congestion Control
                        TCP_CONG_BBR = y;
                        DEFAULT_BBR = y;
                        # Preentive Full Tickless Kernel at 250Hz
                        HZ = f "250";
                        HZ_250 = y;
                        HZ_1000 = n;
                        # RCU_BOOST and RCU_EXP_KTHREAD
                        RCU_EXPERT = y;
                        RCU_FANOUT = f "64";
                        RCU_FANOUT_LEAF = f "16";
                        RCU_BOOST = y;
                        RCU_BOOST_DELAY = f "0";
                        RCU_EXP_KTHREAD = y;
                        # NixOS specific - enable kernel lockdown LSM
                        SECURITY_LOCKDOWN_LSM = mkForce y;
                        MODULE_SIG = mkForce y;
                        # Security features
                        # https://www.kicksecure.com/wiki/Hardened-kernel#Security_features
                        # https://github.com/a13xp0p0v/kernel-hardening-checker/
                        DEBUG_SG = y;
                        DEBUG_NOTIFIERS = y;
                        DEBUG_LIST = y;
                        BUG_ON_DATA_CORRUPTION = y;
                        SCHED_STACK_END_CHECK = y;
                        DEBUG_VIRTUAL = y;
                        INTEL_IOMMU_DEFAULT_ON = y;
                        #GCC_PLUGIN_LATENT_ENTROPY = y;
                        RESET_ATTACK_MITIGATION = y;
                        CRYPTO_JITTERENTROPY = y;
                        HW_RANDOM = y;
                        #HW_RANDOM_AMD = y;
                        HW_RANDOM_INTEL = y;
                        MODULE_SIG_ALL = y;
                        MODULE_SIG_SHA512 = y;
                        MAGIC_SYSRQ = n;
                        MODULE_SIG_FORCE = y;
                        SHUFFLE_PAGE_ALLOCATOR = y;
                        INIT_ON_ALLOC_DEFAULT_ON = y;
                        INIT_ON_FREE_DEFAULT_ON = y;
                        #GCC_PLUGIN_STACKLEAK = y;
                        SECURITY_LOCKDOWN_LSM_EARLY = y;
                        LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY = y;
                        ARCH_MMAP_RND_BITS = f "32";
                        ARCH_MMAP_RND_COMPAT_BITS = f "16";
                        # Kernel self-protection
                        # https://github.com/a13xp0p0v/kernel-hardening-checker/
                        WERROR = mkForce y;
                        EFI_DISABLE_PCI_DMA = y;
                        RANDSTRUCT_FULL = y;
                        RANDSTRUCT_PEFORMANCE = mkForce u;
                        LTO_CLANG_THIN = y;
                        CFI_CLANG = y;
                        CFI_PERMISSIVE = n;
                        RANDOMIZE_KSTACK_OFFSET_DEFAULT = y;
                        DEFAULT_MMAP_MIN_ADDR = f "65536";
                        IOMMU_DEFAULT_DMA_STRICT = y;
                        INTEL_IOMMU_SVM = y;
                        PAGE_TABLE_CHECK = y;
                        PAGE_TABLE_CHECK_ENFORCED = y;
                        CFI_AUTO_DEFAULT = n;
                        # Attack surface reduction
                        # https://www.kicksecure.com/wiki/Hardened-kernel#Attack_surface_reduction
                        # https://github.com/a13xp0p0v/kernel-hardening-checker/
                        DEVMEM = n;
                        DEVPORT = n;
                        LIVEPATCH = mkForce u;
                        KEXEC = n;
                        X86_MSR = n;
                        ACPI_TABLE_UPGRADE = n;
                        SLAB_MERGE_DEFAULT = n;
                        USERFAULTFD = mkForce n;
                        LEGACY_VSYSCALL_NONE = y;
                        X86_VSYSCALL_EMULATION = n;
                        BINFMT_MISC = mkForce n;
                        INET_DIAG = n;
                        COREDUMP = n;
                        CRASH_DUMP = mkForce u;
                        USELIB = n;
                        MODIFY_LDT_SYSCALL = n;
                        KSM = mkForce n;
                        FIREWIRE = n;
                        AIO = mkForce n;
                        SYSFS_SYSCALL = n;
                        PROC_KCORE = n;
                        NOTIFIER_ERROR_INJECTION = n;
                        PROFILING = n;
                        LDISC_AUTOLOAD = n;
                        STAGING = mkForce n;
                        IIO = n;
                        X86_INTEL_TSX_MODE_OFF = y;
                        SECURITY_DMESG_RESTRICT = y;
                        LEGACY_TIOCSTI = n;
                        KPROBE_EVENTS = mkForce u;
                        UPROBE_EVENTS = mkForce u;
                        GENERIC_TRACER = mkForce u;
                        FUNCTION_TRACER = mkForce u;
                        STACK_TRACER = mkForce u;
                        BLK_DEV_IO_TRACE = u;
                        PROC_PAGE_MONITOR = n;
                        CHECKPOINT_RESTORE = mkForce n;
                        HWPOISON_INJECT = n;
                        MEM_SOFT_DIRTY = mkForce u;
                        PUNIT_ATOM_DEBUG = n;
                        ACPI_CONFIGFS = n;
                        MTD_SLRAM = n;
                        MTD_PHRAM = n;
                        RSEQ = n;
                        PROVIDE_OHCI1394_DMA_INIT = n;
                        SUNRPC_DEBUG = mkForce n;
                        BLK_DEV_FD = n;
                        KALLSYMS = n;
                        KEXEC_FILE = mkForce n;
                        X86_CPUID = n;
                        X86_IOPL_IOPERM = n;
                        EFI_CUSTOM_SSDT_OVERLAYS = n;
                        KPROBES = mkForce n;
                        FTRACE = mkForce n;
                        INPUT_EVBUG = n;
                        BLK_DEV_WRITE_MOUNTED = n;
                        TRIM_UNUSED_KSYMS = y;
                        N_GSM = n;
                        # https://madaidans-insecurities.github.io/guides/linux-hardening.html
                        # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
                        # Obscure network protocols
                        ATALK = n;
                        ATM = n;
                        CAN = n;
                        IP_DCCP = n;
                        N_HDLC = n;
                        RDS = n;
                        TIPC = n;
                        X25 = n;
                        # Old, rare, or insufficiently audited filesystems
                        CRAMFS = n;
                        XFS_SUPPORT_V4 = n;
                    }
                    // listToAttrs (
                        map (name: nameValuePair (name + "_FS") n) [
                            # Old, rare, or insufficiently audited filesystems
                            "ADFS"
                            "AFFS"
                            "BFS"
                            "BEFS"
                            "EFS"
                            "EROFS"
                            "VXFS"
                            "HPFS"
                            "JFFS2"
                            "MINIX"
                            "NILFS2"
                            "OMFS"
                            "QNX4FS"
                            "QNX6FS"
                            "SYSV"
                            # Unused network filesystems
                            "GFS2"
                        ]
                    )
                    //
                        genAttrs
                            # Unused options
                            [
                                "X86_AMD_PLATAFORM_DEVICE"
                                "X86_MCE_AMD"
                                "X86_AMD_FREQ_SENSITIVITY"
                                "PERF_EVENTS_AMD_POWER"
                                "AMD_MEM_ENCRYP"
                                "MNATIVE_AMD"
                                "CPU_SUP_AMD"
                                "NET_VENDOR_AMD"
                                "HW_RANDOM_AMD"
                                "I2C_AMD756"
                                "I2C_AMD8111"
                                "I2C_AMD_MP2"
                                "AGP_AMD64"
                                "MICROCODE_AMD"
                                "THUNDERBOLT"
                                "ANDROID"
                                "NVME_SYSFS"
                                "DRM_NOUVEAU_SVM"
                                "INET_DIAG_DESTROY"
                                "INET_MPTCP_DIAG"
                                "INET_RAW_DIAG"
                                "INET_TCP_DIAG"
                                "INET_UDP_DIAG"
                                "IP_DCCP_CCID3"
                                "STRICT_DEVMEM"
                                "IO_STRICT_DEVMEM"
                                "KEXEC_JUMP"
                                "POWER_RESET_GPIO"
                                "POWER_RESET_GPIO_RESTART"
                                "X86_INTEL_TSX_MODE_AUTO"
                                "BPF_EVENTS"
                                "BPF_LSM"
                                "FTRACE_SYSCALLS"
                                "FUNCTION_PROFILER"
                                "HID_BPF"
                                "SCHED_TRACER"
                                "NET_DROP_MONITOR"
                                "RING_BUFFER_BENCHMARK"
                                "CLEAR_CACHEDIR"
                                "RUSTC_LLVM_VERSION"
                                "GCC_PLUGINS"
                                #"RUST"
                                "DRM_PANIC_SCREEN_QR_CODE"
                            ]
                            (name: mkForce u);
            }).overrideAttrs
                {
                    # Ignore benign error that stops build with WERROR=y
                    # https://github.com/ClangBuiltLinux/linux/issues/1983#issuecomment-1904431443
                    env.NIX_CFLAGS_COMPILE = "-Wno-unused-command-line-argument";
                    preInstall =
                        let
                            # Normally there's a second `cp -av $3 $4` line that copies the System.map file;
                            # this makes it so it doesn't get copied to reduce kernel pointer leaks
                            # https://madaidans-insecurities.github.io/guides/linux-hardening.html#other-kernel-pointer-leaks
                            installkernel = buildPackages.writeShellScriptBin "installkernel" ''
                                cp -av $2 $4
                            '';
                        in
                        ''
                            installFlagsArray+=("-j$NIX_BUILD_CORES")
                            export HOME=${installkernel}
                        '';
                }
        );
    };
}

