{
  flake.modules.nixos.intelcpu = {
    hardware.cpu.intel.updateMicrocode = true;
    services = {
      throttled.enable = true;
      thermald.enable = true;
    };
    boot = {
      kernelParams = [
        "intel_pstate=enable"
        "intel_idle.max_cstate=2" # Mejor balance rendimiento/energía
        "intel_iommu=on"
      ];
    };
  };
}
