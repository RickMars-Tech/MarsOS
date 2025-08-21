{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.mars.cpu.intel.enable = mkEnableOption "Intel cpu Config";

  config = mkIf (config.mars.cpu.intel.enable) {
    hardware.cpu.intel.updateMicrocode = true;
    services.throttled.enable = true;
    # Some config has been moved to core/kernel/common.nix

    environment.systemPackages = with pkgs; [
      intel-undervolt
    ];
  };
}
