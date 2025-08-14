{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.mars.power-management;
  isMobile = cfg.profile == "laptop";
  isPerformanceOriented = builtins.elem cfg.profile ["desktop" "workstation"];
in {
  options.mars.power-management = {
    enable = mkEnableOption "Power management" // {default = true;};
    profile = lib.mkOption {
      type = lib.types.enum ["laptop" "desktop" "workstation"];
      default = "desktop";
      description = "Hardware profile for power tuning";
    };
    cpuGovernor = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum ["performance" "powersave" "ondemand" "schedutil"]);
      default = null;
    };
    enableThermalManagement = mkEnableOption "Thermal monitoring" // {default = true;};
  };

  config = mkIf (cfg.enable && !config.mars.gaming.enable) {
    # ⚠️ Solo si NO está en modo gaming
    # CPU scaling (solo si no está en gaming)
    powerManagement.cpuFreqGovernor =
      if cfg.cpuGovernor != null
      then cfg.cpuGovernor
      else
        (
          if isPerformanceOriented
          then "ondemand"
          else "powersave"
        );

    # TLP para laptops
    services.tlp = mkIf isMobile {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC =
          if isPerformanceOriented
          then "ondemand"
          else "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC =
          if isPerformanceOriented
          then "balance_performance"
          else "power";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersupersave";
      };
    };

    # Thermal para laptops (solo si no está en gaming)
    services.thermald = mkIf cfg.enableThermalManagement {
      enable = isMobile;
    };

    # Batería
    services.upower = mkIf isMobile {
      enable = true;
      criticalPowerAction = "Hibernate";
    };

    # Paquetes básicos
    environment.systemPackages = with pkgs; lib.optionals isMobile [tlp upower];
  };
}
