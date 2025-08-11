_: {
  systemd = {
    services = {
      systemd-udev-settle.enable = false; # Skip waiting for udev

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

    #|==< Optimize SystemD >==|#
    settings.Manager = {
      DefaultLimitNOFILE = "2048:524288";
      DefaultLimitMEMLOCK = "infinity";
      DefaultLimitNPROC = "8192";
      DefaultTimeoutStartSec = "30s";
      DefaultTimeoutStopSec = "10s";
    };
  };

  #|==< JourdnalD >==|#
  services.journald = {
    storage = "persistent";
    rateLimitBurst = 1000;
    rateLimitInterval = "30s";
    extraConfig = ''
      SystemMaxUse=50M
    '';
  };
}
