{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  asus = config.mars.asus;
in {
  options.mars.asus = {
    enable = mkEnableOption "Asus Configs" // {default = false;};
    gamemode.enable = mkEnableOption "Integrate with gamemode for gaming performance" // {default = false;};
  };

  config = {
    # Moved to core/kernel/common.nix
    #boot.kernelModules = mkIf (cfg.enable) ["asus-wmi"];
    services.asusd = mkIf (asus.enable) {
      enable = true;
      enableUserService = true;
      package = pkgs.asusctl;
    };
  };
}
