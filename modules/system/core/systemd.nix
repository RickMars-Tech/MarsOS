{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) optionals mkDefault;
  pci-latency = pkgs.callPackage ../../../pkgs/gamingScripts/pciLatency.nix {};
  amd = config.mars.graphics.amd;
  gaming = config.mars.gaming;
in {
  systemd = {
    user.services.niri-flake-polkit.enable = mkDefault false;
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
    tmpfiles.rules =
      [
        # Clear all coredumps that were created more than 3 days ago
        "d /var/lib/systemd/coredump 0755 root root 3d"
        # Improve performance for applications that use tcmalloc
        # https://github.com/google/tcmalloc/blob/master/docs/tuning.md#system-level-optimizations
        "w! /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
      ]
      # ROCm configuration for AI workloads
      ++ optionals (amd.compute.enable && amd.compute.rocm) [
        "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
      ]
      ++ optionals gaming.enable [
        #= Create Steam Runtime Directory with proper Permissions
        "d /tmp/.X11-unix 1777 root root -"
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
