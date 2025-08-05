_: {
  systemd = {
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

    settings.Manager = {
      DefaultLimitNOFILE = "2048:524288";
      DefaultLimitNPROC = "8192";
      DefaultTimeoutStopSec = "10s";
    };
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
