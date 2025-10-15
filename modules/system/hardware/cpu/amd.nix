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
    boot = {
      kernelModules = [
        "amd-pstate"
        "zenpower"
      ];
      kernelParams = [
        "amd_pstate=active"
        # IOMMU support for compute workloads
        "amd_iommu=on"
        "iommu=pt"
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
