{
  pkgs,
  lib,
  ...
}: {
  #= TLP (Advanced Power Management for Linux).
  services = {
    tlp = {
      enable = true;
      settings = {
        # Driver.
        CPU_DRIVER_OPMODE_ON_AC = "active";
        CPU_DRIVER_OPMODE_ON_BAT = "active";

        # Governor.
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        # Performance Policy.
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        # Battery.
        START_CHARGE_THRESH_BAT0 = 50;
        STOP_CHARGE_THRESH_BAT0 = 90;
        # Troubleshooting
        TLP_DEFAULT_MODE = "BAT";
      };
    };
    power-profiles-daemon.enable = false;
    thermald.enable = true;
    upower.enable = true;

    #=> IRQBalance
    irqbalance.enable = false; # It can be disabled on low-core systems.
  };

  # #=> Gamemode
  # programs.gamemode = {
  #   enable = true;
  #   enableRenice = lib.mkDefault true;
  #   settings = {
  #     general = {
  #       renice = 10;
  #       inhibit_screensaver = 0;
  #     };
  #     cpu = {
  #       park_cores = "no";
  #       pin_cores = "yes";
  #     };
  #     custom = {
  #       start = "${pkgs.libnotify}/bin/notify-send 'GameMode Started'";
  #       end = "${pkgs.libnotify}/bin/notify-send 'GameMode Ended'";
  #     };
  #   };
  # };
}
