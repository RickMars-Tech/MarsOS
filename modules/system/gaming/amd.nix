{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  amd = config.mars.graphics.amd;
  gaming = config.mars.gaming;
in {
  options.mars.gaming.gamemode.amdOptimizations = mkEnableOption "AMD Gamemode";

  config = mkIf (gaming.enable && gaming.gamemode.enable && gaming.gamemode.nvidiaOptimizations) {
    # Gaming optimizations when gamemode is available
    programs.gamemode.settings = mkIf (gaming.gamemode.enable && amd.enable) {
      gpu = {
        gpu_device = mkIf amd.enable 1; # Use dGPU for gaming
        amd_performance_level = "high";
      };
    };
  };
}
