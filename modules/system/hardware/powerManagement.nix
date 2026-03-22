{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault mkEnableOption optionalAttrs;
  cfg = config.mars;
  asus = config.mars.hardware.asus;
in {
  options.mars.hardware.laptopOptimizations = mkEnableOption "Laptop Optimizations";

  config = mkIf cfg.hardware.laptopOptimizations {
    services = {
      upower.enable = true;
      thermald.enable = true;

      tlp = {
        enable = true;
        pd.enable = mkDefault true;
        settings =
          {
            CPU_SCALING_GOVERNOR_ON_AC =
              if cfg.gaming.enable
              then "performance"
              else "ondemand";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            CPU_BOOST_ON_AC = 1;
            CPU_BOOST_ON_BAT = 0;
            CPU_HWP_DYN_BOOST_ON_AC = 1;
            CPU_HWP_DYN_BOOST_ON_BAT = 0;
            CPU_MIN_PERF_ON_AC = 0;
            CPU_MAX_PERF_ON_AC = 100;
            CPU_MIN_PERF_ON_BAT = 0;
            CPU_MAX_PERF_ON_BAT = 50;
            TURBO_BOOST_ON_AC = 1;
            TURBO_BOOST_ON_BAT = 0;
            SOUND_POWER_SAVE_ON_AC = 0;
            SOUND_POWER_SAVE_ON_BAT = 1;
            WIFI_PWR_ON_AC = "off";
            WIFI_PWR_ON_BAT = "on";
            RESTORE_DEVICE_STATE_ON_STARTUP = 0;
          }
          // optionalAttrs (!asus.enable) {
            # Only if AsusCtl is Disabled
            STOP_CHARGE_THRESH_BAT0 = 80;
            PLATFORM_PROFILE_ON_AC = "performance";
            PLATFORM_PROFILE_ON_BAT = "low-power";
          };
      };
    };
  };
}
