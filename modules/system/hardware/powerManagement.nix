{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault mkEnableOption;
  cfg = config.mars;
in {
  options.mars.laptopOptimizations = mkEnableOption "Laptop Optimizations";
  config = mkIf cfg.laptopOptimizations {
    services.logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitchDocked = "ignore";
    };

    services.upower.enable = true;
    services.power-profiles-daemon.enable = mkDefault true;
  };
}
