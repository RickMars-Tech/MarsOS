{
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
    # Some configs has been moved to core/kernel/common.nix
  };
}
