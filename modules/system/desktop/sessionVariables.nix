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
  intel = config.mars.graphics.intel;
  gaming = config.mars.gaming.gamemode;
  steam = config.mars.gaming.steam;
  minecraft = config.mars.gaming.minecraft.prismlauncher;
  #= Packages
  firefox = "${pkgs.firefox}/bin/firefox";
  terminal = "${pkgs.wezterm}/bin/wezterm";
  soteria = getExe pkgs.soteria;
in {
  environment = {
    pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];
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
        #= Shader Optimizations
        # https://github.com/psygreg/shader-booster/
        AMD_VULKAN_ICD = "RADV";
        RADV_PERFTEST = "gpl,ngg,sam,rt";

        #= GameMode optimizations
        MESA_SHADER_CACHE_MAX_SIZE = mkIf gaming.amdOptimizations "12G";

        #= GameMode: Use Nouveau dGPU if available in hybrid setup
        GAMEMODERUNEXEC = mkIf (gaming.amdOptimizations && nvidiaFree.enable) "DRI_PRIME=1";
      })

      #= AMD Compute Environment
      (mkIf (amd.compute.enable && amd.compute.rocm) {
        # ROCm environment
        ROCM_PATH = "${pkgs.rocmPackages.clr}";
        HIP_PATH = "${pkgs.rocmPackages.hip-common}";
      })

      #|==< Intel >==|#
      (mkIf intel.enable {
        #= GameMode: Use Nouveau dGPU if available in hybrid setup
        GAMEMODERUNEXEC = mkIf (gaming.enable && nvidiaFree.enable) "DRI_PRIME=1";
      })

      #|==< nVidiaFree (Nouveau) >==|#
      (mkIf nvidiaFree.enable {
        __GLX_VENDOR_LIBRARY_NAME = "mesa";

        #= Force Zink on Nouveau (experimental)
        MESA_LOADER_DRIVER_OVERRIDE = mkIf nvidiaFree.zink "zink";

        #= GameMode: Use Nouveau dGPU automatically in hybrid setups
        # Only if nvidiaPro is NOT enabled
        GAMEMODERUNEXEC = mkIf (gaming.nvidiaOptimizations && !nvidiaPro.enable) "DRI_PRIME=1";

        #= Shader cache for Nouveau
        MESA_SHADER_CACHE_MAX_SIZE = mkIf gaming.nvidiaOptimizations "10G";
      })

      #|==< nVidiaPRO (Proprietary) >==|#
      (mkIf nvidiaPro.enable {
        #= Shader Optimizations
        # https://github.com/psygreg/shader-booster/
        __GL_SHADER_DISK_CACHE_SIZE = 12000000000;
        __GL_SHADER_DISK_CACHE = "1";
        __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
        GBM_BACKEND = "nvidia-drm";

        CUDA_DISABLE_PERF_BOOST = mkIf (!nvidiaPro.compute.cuda) "1";

        #= GameMode: Use NVIDIA PRIME
        GAMEMODERUNEXEC = mkIf (gaming.nvidiaOptimizations && nvidiaPro.prime.enable) "prime-run";
      })

      #|==< Steam >==|#
      (mkIf steam.enable {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";

        # https://wiki.cachyos.org/configuration/gaming/#fix-stuttering-caused-by-the-steam-game-recorder-feature
        LD_PRELOAD = "";

        #= Load Shared Objects Immediately
        LD_BIND_NOW = "1";
        STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "0";

        #= PROTON
        PROTON_USE_WOMED3D = "0";
        PROTON_NO_ESYNC = "0";
        PROTON_NO_FSYNC = "0";
        PROTON_ENABLE_NVAPI = mkIf nvidiaPro.enable "1";
        PROTON_ENABLE_NGX_UPDATER = mkIf nvidiaPro.enable "1";

        #= VKD3D
        VKD3D_CONFIG = "dxr";

        #= DXVK
        DXVK_HUD = "compiler";
        DXVK_STATE_CACHE_PATH = "$HOME/.cache/dxvk";

        #= Wine
        WINEPREFIX = "$HOME/.wine";
        WINEARCH = "win64";
        WINE_CPU_TOPOLOGY = "4:2";
      })

      #|==< JAVA >==|#
      (mkIf minecraft.enable {
        _JAVA_AWT_WM_NONREPARENTING = "1";
      })
    ];
  };
}
