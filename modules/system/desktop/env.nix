{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe mkIf;
  nvidia = config.mars.graphics.nvidiaPro;
  amd = config.mars.graphics.amd;
  firefox = "${pkgs.firefox}/bin/firefox";
  terminal = "${pkgs.wezterm}/bin/wezterm";
  soteria = getExe pkgs.soteria;
  steam = config.mars.gaming.steam;
  minecraft = config.mars.gaming.minecraft.prismlauncher;
in {
  environment = {
    sessionVariables = {
      #|==< Default's >==|#
      EDITOR = "hx";
      BROWSER = "${firefox}";
      TERMINAL = "${terminal}";

      #|==< Polkit >==|#
      POLKIT_BIN = "${soteria}";

      #|==< ShaderOptimizations >==|#
      AMD_VULKAN_ICD = mkIf amd.enable "RADV";
      MESA_SHADER_CACHE_MAX_SIZE = mkIf amd.enable "12G";
      __GL_SHADER_DISK_CACHE_SIZE = mkIf nvidia.enable 12000000000;

      #|==< nVidiaPrime >==|#
      GAMEMODERUNEXEC = mkIf nvidia.enable "nvidia-offload";

      #|==< JAVA >==|#
      _JAVA_AWT_WM_NONREPARENTING = mkIf minecraft.enable "1";

      #|==< Load Shared Objects Immediately >==|#
      LD_BIND_NOW = mkIf steam.enable "1";

      #|==< Steam >==|#
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = mkIf steam.enable "$HOME/.steam/root/compatibilitytools.d";
      # https://wiki.cachyos.org/configuration/gaming/#fix-stuttering-caused-by-the-steam-game-recorder-feature
      LD_PRELOAD = mkIf steam.enable "";
    };
  };
}
