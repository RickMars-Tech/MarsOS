{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  rcu-power-manager = pkgs.callPackage ../../../pkgs/gamingScripts/rcu-power-manager.nix {};
  cfg = config.mars;
in {
  options.mars.laptopOptimizations = mkEnableOption "Laptop Optimizations";

  config = mkIf cfg.laptopOptimizations {
    # Lid
    services.logind.lidSwitch = "poweroff";
    services.logind.lidSwitchExternalPower = "lock";
    services.logind.lidSwitchDocked = "ignore";

    #= RCU
    boot.kernelParams = [
      "rcutree.enable_rcu_lazy=1"
    ];
    environment.systemPackages = [rcu-power-manager];

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

        # Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
        # TLP_DEFAULT_MODE = "BAT";
        # TLP_PERSISTENT_DEFAULT = 1;
      };
    };
    powerManagement = {
      enable = true;
      powerUpCommands = ''
        sleep 2
        echo 0 > /sys/module/rcutree/parameters/enable_rcu_lazy 2>/dev/null || true
      '';
      powerDownCommands = ''
        sleep 2
        echo 1 > /sys/module/rcutree/parameters/enable_rcu_lazy 2>/dev/null || true
      '';
    };
  };
}
