{
  config,
  pkgs,
  lib,
  ...
}: {
  options.mars.asus = {
    enable = lib.mkEnableOption "Asus Configs";
    gamemode.enable = lib.mkEnableOption "Integrate with gamemode for gaming performance";
  };

  config = let
    cfg = config.mars.asus;
  in {
    boot.kernelModules = lib.mkIf (cfg.enable) ["asus-wmi"];
    services.asusd = lib.mkIf (cfg.enable) {
      enable = true;
      package = pkgs.asusctl;
    };
    programs.gamemode.settings = lib.mkIf (cfg.enable && cfg.gamemode.enable) {
      custom = {
        start = "${pkgs.asusctl}/bin/asusctl profile -p Turbo";
        end = "${pkgs.asusctl}/bin/asusctl profile -p Balanced";
      };
    };
  };
}
