{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.mars.cpu.amd.enable = mkEnableOption "amd cpu";

  config = mkIf (config.mars.cpu.amd.enable) {
    # Enable microcode updates for AMD CPUs
    hardware.cpu.amd.updateMicrocode = true;
    # All config moved to core/kernel/common.nix
  };
}
