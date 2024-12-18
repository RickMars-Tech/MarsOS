{ pkgs, ... }: {

    systemd = {
        enableCgroupAccounting = false;
        /*tmpfiles.rules = [
        # https://wiki.archlinux.org/title/Gaming#Make_the_changes_permanent.
            "w     /proc/sys/vm/compaction_proactiveness - - - - 0"
            "w     /proc/sys/vm/watermark_boost_factor - - - - 1"
            "w     /proc/sys/vm/min_free_kbytes - - - - 1048576"
            "w     /proc/sys/vm/watermark_scale_factor - - - - 500"
            "w     /sys/kernel/mm/lru_gen/enabled - - - - 5"
            "w     /proc/sys/vm/zone_reclaim_mode - - - - 0"
            "w     /sys/kernel/mm/transparent_hugepage/enabled - - - - madvise"
            "w     /sys/kernel/mm/transparent_hugepage/shmem_enabled - - - - advise"
            "w     /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
            "w     /proc/sys/vm/page_lock_unfairness - - - - 1"
            "w     /proc/sys/kernel/sched_child_runs_first - - - - 0"
            "w     /proc/sys/kernel/sched_autogroup_enabled - - - - 1"
            "w     /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 3000"
            "w     /sys/kernel/debug/sched/base_slice_ns  - - - - 3000000"
            "w     /sys/kernel/debug/sched/migration_cost_ns - - - - 500000"
            "w     /sys/kernel/debug/sched/nr_migrate - - - - 8"
        # https://wiki.archlinux.org/title/Professional_audio#System_configuration
            "w     /sys/class/rtc/rtc0/max_user_freq - - - -  3072"
            "w     /proc/sys/dev/hpet/max-user-freq  - - - -  3072"
        ];*/

    #=> Polkit Service.
        user.services.polkit-gnome-authentication-agent-1 = {
            description = "polkit-gnome-authentication-agent-1";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
                TimeoutStopSec = 10;
            };
        };

    #=> Greetd Service
        # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
        services.greetd.serviceConfig = {
            Type = "idle";
            StandardError = "journal"; # Without this errors will spam on screen
            # Without these bootlogs will spam on screen
            TTYReset = true;
            TTYVHangup = true;
            TTYVTDisallocate = true;
        };

    #==> Extra Configurations
        extraConfig = ''
            [Manager]
            DefaultLimitNOFILE=2048:2097152
            DefaultTimeoutStopSec=10s
        '';
        user.extraConfig = ''
            [Manager]
            DefaultLimitNOFILE=2048:1048576
        '';
    };

#==> JourdnalD
    services.journald = {
        storage = "persistent";
        rateLimitBurst = 10000;
        rateLimitInterval = "30s";
        extraConfig = ''
            SystemMaxUse=50M
        '';
    };

}
