{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  gaming = config.mars.gaming;
in {
  options.mars.gaming.gamemode.nvidiaOptimizations = mkEnableOption "nVidia Gamemode";

  config = mkIf (gaming.enable && gaming.gamemode.enable && gaming.gamemode.nvidiaOptimizations) {
    # Moved to desktop/env.nix
  };
}
