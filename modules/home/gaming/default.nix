{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge mkEnableOption;
  # Options
  asus = config.mars.hardware.asus.gamemode;
  gaming = config.mars.gaming;
  steam = config.mars.gaming.steam;
  minecraft = config.mars.gaming.minecraft.prismlauncher;
  # nvidiaPro = config.mars.graphics.nvidiaPro;
  amd = config.mars.hardware.graphics.amd;
in {
  imports = [
    ./launchers
    ./dxvk.nix
    ./gamescope.nix
    ./packages.nix
  ];

  options.mars.gaming = {
    enable = mkEnableOption "Gaming Config" // {default = false;};
    gamemode = {
      enable = mkEnableOption "Feral Gamemode" // {default = false;};
      nvidiaOptimizations = mkEnableOption "nVidia Gamemode (works with both Pro and Free)";
      amdOptimizations = mkEnableOption "AMD Gamemode";
    };
    extra-gaming-packages = mkEnableOption "Some Extra Games/Packages";
  };

  config = mkIf gaming.enable {
    # Validaciones
    assertions = [
      {
        assertion = !(gaming.gamemode.nvidiaOptimizations && gaming.gamemode.amdOptimizations);
        message = "Cannot enable both NVIDIA and AMD gamemode optimizations simultaneously";
      }
    ];

    hardware.uinput.enable = true;

    # Gaming-optimized environment variables
    environment.sessionVariables = mkMerge [
      {
        MANGOHUD_CONFIG = ''control=mangohud,legacy_layout=0,horizontal,background_alpha=0,gpu_stats,gpu_power,gpu_temp,cpu_stats,cpu_temp,ram,vram,ps,fps,fps_metrics=AVG,0.001,font_scale=1.05'';
      }
      # Steam
      (mkIf steam.enable {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

        # https://wiki.cachyos.org/configuration/gaming/#fix-stuttering-caused-by-the-steam-game-recorder-feature
        LD_PRELOAD = "";

        # Gaming-specific OpenGL optimizations
        __GL_THREADED_OPTIMIZATIONS = "1";
        __GL_SHADER_DISK_CACHE = "1";
        __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";

        # DXVK optimizations
        DXVK_LOG_LEVEL = "none";
        DXVK_CONFIG_FILE = "/etc/dxvk.conf";

        # Proton optimizations
        PROTON_USE_WINED3D = "0";
        PROTON_NO_ESYNC = "0";
        PROTON_NO_FSYNC = "0";
        # PROTON_ENABLE_NVAPI = "1";

        # Wine
        WINEPREFIX = "$HOME/.wine";
        WINEARCH = "win64";
      })

      # Java
      (mkIf minecraft.enable {
        _JAVA_AWT_WM_NONREPARENTING = "1";
      })
    ];

    # Gamemode
    programs.gamemode = mkIf gaming.gamemode.enable {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          renice = 10;
          ioprio = 7;
          inhibit_screensaver = 1;
          disable_splitlock = 1;
          softrealtime = "auto";
          desiredgov = "performance";
          igpu_desiredgov = "powersave";
          igpu_power_threshold = 0.3;
        };

        # GPU-specific settings
        gpu =
          # AMD optimizations
          mkIf (gaming.gamemode.amdOptimizations && amd.enable) {
            amd_performance_level = "high";
            apply_gpu_optimisations = "accept-responsibility";
          };
        # NVIDIA optimizations (both Pro and Free)
        # // (mkIf (gaming.gamemode.nvidiaOptimizations && (nvidiaPro.enable || nvidiaFree.enable)) {
        #   apply_gpu_optimisations = "accept-responsibility";
        # });

        cpu = {
          park_cores = "no";
          pin_cores = "yes";
        };

        filter.whitelist = "steam";

        # ASUS laptop profile switching
        custom = {
          start = mkIf asus.enable "${pkgs.asusctl}/bin/asusctl profile -p Turbo";
          end = mkIf asus.enable "${pkgs.asusctl}/bin/asusctl profile -p Balanced";
        };
      };
    };

    # Gaming-specific tmpfiles
    systemd.tmpfiles.rules = [
      # Create Steam runtime directory with proper permissions
      "d /tmp/.X11-unix 1777 root root -"

      # Ensure proper permissions for audio
      "d /dev/snd 0755 root audio -"

      # Create directory for MangoHud configs
      "d /etc/mangohud 0755 root root -"
    ];
  };
}
