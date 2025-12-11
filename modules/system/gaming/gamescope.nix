{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  gaming = config.mars.gaming;
  gamescope = config.mars.gaming.gamescope;
in {
  options.mars.gaming.gamescope = {
    enable = mkEnableOption "Enable Gamescope" // {default = false;};
  };
  config = {
    programs.gamescope = {
      enable = mkIf (gaming.enable && gamescope.enable) true;
      package = pkgs.gamescope;
      capSysNice = true;
      args = [
        "-e"
        "--force-grab-cursor"
        "--expose-wayland" #= Support Wayland Clients
        "--rt" #= Use Realtime Scheduling
        # "--adaptive-sync" #= Vrr
      ];
    };
  };
}
