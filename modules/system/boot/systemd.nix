{
  pkgs,
  lib,
  ...
}: {
  systemd = {
    enableCgroupAccounting = true;

    user.services = {
      cliphist = {
        description = "wl-paste + cliphist service";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.wl-clipboard-rs}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
          Restart = "on-failure";
        };
      };
      #|==> Xwayland-Satellite <==|#
      /*
         xwayland-satellite = {
        enable = true;
        description = "Xwayland Satellite Service.";
        bindsTo = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        after = ["graphical-session.target"];
        requisite = ["graphical-session.target"];

        serviceConfig = {
          Type = "notify";
          NotifyAccess = "all";
          ExecStart = lib.getExe pkgs.xwayland-satellite;
          StandardOutput = "journal";
          Restart = "on-failure"; # Reiniciar si falla
          Environment = "DISPLAY=:0"; # Ajusta según tu configuración de DISPLAY
        };
      };
      */
    };

    services = {
      #|==> GreetD <==|#
      # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
      greetd.serviceConfig = {
        Type = "idle";
        StandardError = "journal"; # Without this errors will spam on screen
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };

    #|==> Extra Configurations <==|#
    extraConfig = ''
      [Manager]
      DefaultLimitNOFILE=2048:524288
      DefaultLimitNPROC=8192
      DefaultTimeoutStopSec=10s
    '';
    user.extraConfig = ''
      [Manager]
      DefaultLimitNOFILE=2048:262144
      DefaultLimitNPROC=4096
    '';
  };

  #|==> JourdnalD <==|#
  services.journald = {
    storage = "persistent";
    rateLimitBurst = 1000;
    rateLimitInterval = "30s";
    extraConfig = ''
      SystemMaxUse=50M
    '';
  };
}
