{
  config,
  lib,
  ...
}: {
  options.mars.cpu.amd.enable = lib.mkEnableOption "amd cpu";

  config = lib.mkIf (config.mars.cpu.amd.enable) {
    # Enable microcode updates for AMD CPUs
    hardware.cpu.amd.updateMicrocode = true;

    boot = {
      kernelParams = [
        "amd_pstate=active"
        # "amd_iommu=on" # Solo si usas virtualización.
      ];
      kernelModules = ["amd-pstate-epp" "zenpower"];
      blacklistedKernelModules = ["k10temp"];
      extraModulePackages = with config.boot.kernelPackages; [zenpower];
    };
  };
}
