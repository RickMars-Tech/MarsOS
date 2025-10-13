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

  config = mkIf (asus.enable) {
    # Moved to core/kernel/common.nix
    boot = {
      kernelModules = ["asus-wmi"];
      kernelParams = ["acpi_backlight="];
    };
    services.asusd = {
      enable = true;
      enableUserService = true;
      package = pkgs.asusctl;
    };
  };
}
