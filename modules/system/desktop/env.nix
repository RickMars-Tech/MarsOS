{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe mkIf mkMerge;
  #= Options
  nvidiaPro = config.mars.graphics.nvidiaPro;
  nvidiaFree = config.mars.graphics.nvidiaFree;
  amd = config.mars.graphics.amd;
  gaming = config.mars.gaming.gamemode;
  steam = config.mars.gaming.steam;
  minecraft = config.mars.gaming.minecraft.prismlauncher;
  #= Packages
  firefox = "${pkgs.firefox}/bin/firefox";
  terminal = "${pkgs.wezterm}/bin/wezterm";
  soteria = getExe pkgs.soteria;
in {
  environment = {
    sessionVariables = mkMerge [
      {
        #|==< Default's >==|#
        EDITOR = "hx";
        BROWSER = "${firefox}";
        TERMINAL = "${terminal}";

        #|==< Polkit >==|#
        POLKIT_BIN = "${soteria}";
      }
      #|==< AMD >==|#
      (mkIf amd.enable {
        # https://reddit.com/r/linux_gaming/comments/1mg8vtl/low_latency_gaming_guide/
        MESA_VK_WSI_PRESENT_MODE = mkIf (gaming.amdOptimizations && amd.enable) "fifo";

        #= ShaderOptimizations
        # https://github.com/psygreg/shader-booster/
        AMD_VULKAN_ICD = "RADV";
        MESA_SHADER_CACHE_MAX_SIZE = mkIf (gaming.amdOptimizations && amd.enable) "12G";

        RADV_PERFTEST = "gpl,ngg,sam,rt";
      })

      #= AMD Compute Environment
      (mkIf (amd.compute.enable && amd.compute.rocm) {
        # ROCm environment
        ROCM_PATH = "${pkgs.rocmPackages.clr}";
        HIP_PATH = "${pkgs.rocmPackages.hip-common}";
      })

      #|==< nVidiaFree >==|#
      (mkIf nvidiaFree.enable {
        __GLX_VENDOR_LIBRARY_NAME = "mesa";
        #= Force Zink on Nouveau
        MESA_LOADER_DRIVER_OVERRIDE = mkIf nvidiaFree.zink "zink";

        #= Use Nvidia GPU with FeralGamemode
        GAMEMODERUNEXEC = mkIf (gaming.nvidiaOptimizations && nvidiaFree.enable) "DRI_PRIME=1";
      })

      #|==< nVidiaPRO >==|#
      (mkIf nvidiaPro.enable {
        #= ShaderOptimizations
        # https://github.com/psygreg/shader-booster/
        __GL_SHADER_DISK_CACHE_SIZE = 12000000000;
        __GL_SHADER_DISK_CACHE = "1";
        __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";

        #= Prime
        GAMEMODERUNEXEC = mkIf (gaming.nvidiaOptimizations && nvidiaPro.enable) "prime-run";
      })

      #|==< Steam >==|#
      (mkIf steam.enable {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
        # https://wiki.cachyos.org/configuration/gaming/#fix-stuttering-caused-by-the-steam-game-recorder-feature
        LD_PRELOAD = "";
        #= Load Shared Objects Immediately
        LD_BIND_NOW = "1";
      })

      #|==< JAVA >==|#
      (mkIf minecraft.enable {
        _JAVA_AWT_WM_NONREPARENTING = "1";
      })
    ];
  };
}
