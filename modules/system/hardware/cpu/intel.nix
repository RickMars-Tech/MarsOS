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
    boot = {
      kernelModules = [
        "amd-pstate"
        "zenpower"
      ];
      kernelParams = [
        "intel_pstate=enable"
        "intel_idle.max_cstate=2" # Mejor balance rendimiento/energía
        "intel_iommu=on"
      ];
      extraModulePackages = with config.boot.kernelPackages; [zenpower];
      blacklistedKernelModules = [
        # set zenpower in place of this:
        "k10temp"
        "sp5100_tco"
      ];
    };
  };
}
