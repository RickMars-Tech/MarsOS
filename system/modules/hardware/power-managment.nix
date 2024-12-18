{ pkgs, lib, ... }: {

#= TLP (Advanced Power Management for Linux).
    services.tlp = {
        enable = true;
        settings = {

        # Driver.
            CPU_DRIVER_OPMODE_ON_AC = "passive";
            CPU_DRIVER_OPMODE_ON_BAT = "passive";

        # Governor.
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "ondemand"; #"schedutil";

        # Performance Policy.
            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        # CPU.
            CPU_BOOST_ON_AC = 1;
            CPU_BOOST_ON_BAT = 0;
            CPU_HWP_DYN_BOOST_ON_AC=1;
            CPU_HWP_DYN_BOOST_ON_BAT=0;
            CPU_MIN_PERF_ON_AC = 0;
            CPU_MAX_PERF_ON_AC = 100;
            CPU_MIN_PERF_ON_BAT = 0;
            CPU_MAX_PERF_ON_BAT = 70;

        # GPU
            INTEL_GPU_MIN_FREQ_ON_AC = 650;
            INTEL_GPU_MIN_FREQ_ON_BAT = 650;
            INTEL_GPU_MAX_FREQ_ON_AC = 1300;
            INTEL_GPU_MAX_FREQ_ON_BAT = 1000;
            INTEL_GPU_BOOST_FREQ_ON_AC = 1300;
            INTEL_GPU_BOOST_FREQ_ON_BAT = 1000;
        
        # Runtime Power Management and ASPM.
            RUNTIME_PM_ON_AC = "auto";
            RUNTIME_PM_ON_BAT = "auto";

        # Battery.
            START_CHARGE_THRESH_BAT0 = 95;
            STOP_CHARGE_THRESH_BAT0 = 100;

        # ACPI
            NATACPI_ENABLE = 1;
            TPACPI_ENABLE = 1;
            TPSMAPI_ENABLE = 1;

        # NMI_Watchdog
            NMI_WATCHDOG = 1;

        # Troubleshooting
            TLP_DEFAULT_MODE = "BAT";
            TLP_PERSISTENT_DEFAULT = 1;
        };
    };
    services.power-profiles-daemon.enable = false;

    services.thermald = {
        enable = true;
    };

    services.preload = {
        enable = true;
    };

#=> IRQBalance
    services.irqbalance.enable = lib.mkDefault true;

#=> Gamemode
    programs.gamemode = {
        enable = true;
        enableRenice = lib.mkDefault true;
        settings = {
            general = {
                renice = 10;
                inhibit_screensaver = 0;
            };    
            gpu = {
                apply_gpu_optimisations = "accept-responsibility";
                amd_performance_level = "high";
            };
            cpu = {
                park_cores = "no";
                pin_cores = "yes";
            };
            custom = {
                start = "${pkgs.libnotify}/bin/notify-send 'GameMode Started'";
                end = "${pkgs.libnotify}/bin/notify-send 'GameMode Ended'";
            };
        };
    };

}
