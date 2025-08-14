{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.mars.asus = {
    enable = mkEnableOption "Asus Configs" // {default = false;};
    gamemode.enable = mkEnableOption "Integrate with gamemode for gaming performance" // {default = false;};
  };

  config = let
    cfg = config.mars.asus;
  in {
    boot.kernelModules = mkIf (cfg.enable) ["asus-wmi"];
    services.asusd = mkIf (cfg.enable) {
      enable = true;
      package = pkgs.asusctl;
    };
    programs.gamemode.settings = mkIf (cfg.enable && cfg.gamemode.enable && config.gaming.gamemode) {
      custom = {
        start = "${pkgs.asusctl}/bin/asusctl profile -p Turbo";
        end = "${pkgs.asusctl}/bin/asusctl profile -p Balanced";
      };
    };
  };
}
