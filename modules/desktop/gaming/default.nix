{
  flake.modules.nixos.gaming =
    {
      self,
      pkgs,
      ...
    }:
    {
      imports = with self.modules.nixos; [
        gamingLaunchers
        gaming-optimizations
      ];

      # Gamemode
      programs.gamemode = {
        enable = true;
        enableRenice = true;
      };

      environment = {
        systemPackages = with pkgs; [
          mangohud # Vulkan and OpenGL overlay for monitoring
          goverlay # Graphical UI to manage overlays
          libstrangle # Frame rate limiter
          lm_sensors # Temperature monitoring
          vkbasalt # Vulkan post-processing layer
          pciutils
          zink-run # Vulkan translation layer to OpenGL
        ];
        # DXVK configuration
        etc."dxvk.conf".text = ''
          # DXVK configuration for gaming optimization

          # Enable State Cache
          dxvk.enableStateCache = True

          # GPU selection (auto-detect)
          # dxvk.gpuSelection = 0

          # Memory allocation
          dxvk.maxFrameLatency = 1
          dxvk.numCompilerThreads = 0

          # Shader compilation
          dxvk.useRawSsbo = True

          # D3D11 specific
          d3d11.constantBufferRangeCheck = False
          d3d11.relaxedBarriers = True
          d3d11.maxTessFactor = 64
        '';
      };

      # Some Gaming-specific tmpfiles
      systemd.tmpfiles.rules = [
        # Create Steam runtime directory with proper permissions
        "d /tmp/.X11-unix 1777 root root -"

        # Ensure proper permissions for audio
        "d /dev/snd 0755 root audio -"

        # Create directory for MangoHud configs
        "d /etc/mangohud 0755 root root -"
      ];

      security. # Gaming-Related PAM Limits
      pam = {
        loginLimits = [
          {
            domain = "@games";
            type = "soft";
            item = "rtprio";
            value = "99";
          }
          {
            domain = "@games";
            type = "hard";
            item = "rtprio";
            value = "99";
          }
          {
            domain = "@games";
            type = "soft";
            item = "nice";
            value = "-20";
          }
          {
            domain = "@games";
            type = "hard";
            item = "nice";
            value = "-20";
          }
        ];
      };
    };
}
