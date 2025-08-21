{pkgs, ...}: let
  pci-latency = pkgs.callPackage ../../../pkgs/gamingScripts/pciLatency.nix {};
  rcu-power-manager = pkgs.callPackage ../../../pkgs/gamingScripts/rcu-power-manager.nix {};
in {
  systemd = {
    user.services.niri-flake-polkit.enable = false;
    services = {
      systemd-udev-settle.enable = false; # Skip waiting for udev

      #|==< PCI Latency >==|#
      pci-latency = {
        description = "Set PCI Latency Timers at boot";
        wantedBy = ["multi-user.target"];
        after = ["basic.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pci-latency}/bin/pci-latency";
        };
      };

      #|==< RCU >==|#
      rcu-power-manager = {
        description = "Dynamic RCU Lazy Power Management";
        wantedBy = ["multi-user.target"];
        after = ["multi-user.target" "tlp.service"]; # Después de TLP
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${rcu-power-manager}/bin/rcu-power-manager";
          # Let write on /sys
          PrivateDevices = false;
          PrivateNetwork = false;
        };
      };

      #|==< GreetD >==|#
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

    #|==< Tmpfiles >==|#
    tmpfiles.rules = [
      # Clear all coredumps that were created more than 3 days ago
      "d /var/lib/systemd/coredump 0755 root root 3d"
      # Improve performance for applications that use tcmalloc
      # https://github.com/google/tcmalloc/blob/master/docs/tuning.md#system-level-optimizations
      "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
    ];
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
