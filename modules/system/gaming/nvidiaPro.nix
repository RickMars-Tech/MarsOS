{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  # nvidia = config.mars.graphics.nvidiaPro;
  gaming = config.mars.gaming;
in {
  options.mars.gaming.gamemode.nvidiaOptimizations = mkEnableOption "nVidia Gamemode";

  config = mkIf (gaming.enable && gaming.gamemode.enable && gaming.gamemode.nvidiaOptimizations) {
    # Moved to desktop/env.nix
    # Custom FeralGamemode Integration With Nvidia Prime Offload
    # environment.sessionVariables.GAMEMODERUNEXEC = "nvidia-offload";
  };
}
