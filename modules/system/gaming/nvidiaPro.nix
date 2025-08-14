{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  nvidia = config.mars.graphics.nvidiaPro;
  gaming = config.mars.gaming;
in {
  options.mars.gaming.gamemode.nvidiaOptimizations = mkEnableOption "nVidia Gamemode";

  config = mkIf (gaming.enable && gaming.gamemode.enable && gaming.gamemode.nvidiaOptimizations) {
    # Gaming optimizations when gamemode is available
    programs.gamemode.settings = mkIf (gaming.gamemode.enable && nvidia.enable) {
      gpu.nv_powermizer_mode = 1; # "Adaptive"=0 "Prefer Maximum Performance"=1 and "Auto"=2
    };
  };
}
