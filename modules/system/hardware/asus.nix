{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkForce mkEnableOption;
  p = pkgs.writeScriptBin "charge-upto" ''
    #!${pkgs.bash}/bin/bash
    echo ''${1:-100} > /sys/class/power_supply/BAT?/charge_control_end_threshold
  '';
  asus = config.mars.asus;
  battery = config.mars.asus.battery;
in {
  options.mars.asus = {
    enable = mkEnableOption "Asus Configs" // {default = false;};
    battery = {
      chargeUpto = lib.mkOption {
        description = "Maximum level of charge for your battery, as a percentage.";
        default = 100;
        type = lib.types.int;
      };
      enableChargeUptoScript = lib.mkOption {
        description = "Whether to add charge-upto to environment.systemPackages. `charge-upto 75` temporarily sets the charge limit to 75%.";
        default = true;
        type = lib.types.bool;
      };
    };
    gamemode.enable = mkEnableOption "Integrate with gamemode for gaming performance" // {default = false;};
  };

  config = mkIf asus.enable {
    boot = {
      kernelModules = ["asus-wmi"];
      kernelParams = ["acpi_backlight="];
    };
    services.asusd = {
      enable = true;
      enableUserService = true;
      package = pkgs.asusctl;
    };

    #= Battery
    environment.systemPackages = mkIf battery.enableChargeUptoScript [p];
    systemd.services.battery-charge-threshold = {
      wantedBy = [
        "local-fs.target"
        "suspend.target"
        "suspend-then-hibernate.target"
        "hibernate.target"
      ];
      after = [
        "local-fs.target"
        "suspend.target"
        "suspend-then-hibernate.target"
        "hibernate.target"
      ];
      description = "Set the battery charge threshold to ${toString battery.chargeUpto}%";
      startLimitBurst = 5;
      startLimitIntervalSec = 1;
      serviceConfig = {
        Type = "oneshot";
        Restart = "on-failure";
        ExecStart = "${pkgs.runtimeShell} -c 'echo ${toString battery.chargeUpto} > /sys/class/power_supply/BAT?/charge_control_end_threshold'";
      };
    };

    #= make problems with Nouveau and its not needed for Nvidia Privative Driver
    # and for some reason, its enabled by asusd
    services.supergfxd.enable = mkForce false;
  };
}
