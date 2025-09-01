{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.mars;
in {
  options.mars.laptopOptimizations = mkEnableOption "Laptop Optimizations";

  config = mkIf cfg.laptopOptimizations {
    # Lid
    services.logind.settings.Login = {
      HandleLidSwitch = "hybrid-sleep";
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitchDocked = "ignore";
    };

    # UPower
    services.upower.enable = true;

    # TLP
    services.tlp = {
      enable = true;
      settings = {
        CPU_DRIVER_OPMODE_ON_AC = "active";
        CPU_DRIVER_OPMODE_ON_BAT = "active";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        # Wifi
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
        WOL_DISABLE = "Y";

        # Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        START_CHARGE_THRESH_BAT1 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT1 = 80; # 80 and above it stops charging
        # TLP_DEFAULT_MODE = "BAT";
        # TLP_PERSISTENT_DEFAULT = 1;
      };
    };
  };
}
