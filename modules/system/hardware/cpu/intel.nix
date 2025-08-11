{
  pkgs,
  config,
  lib,
  ...
}: {
  options.mars.cpu.intel.enable = lib.mkEnableOption "Intel cpu Config";

  config = lib.mkIf (config.mars.cpu.intel.enable) {
    hardware.cpu.intel.updateMicrocode = true;
    boot = {
      kernelParams = [
        "intel_pstate=enable"
        "intel_idle.max_cstate=2" # Mejor balance rendimiento/energía
        "intel_iommu=on"
      ];
    };
    services = {
      throttled = {
        enable = true;
        extraConfig = "";
      };
    };
    environment.systemPackages = with pkgs; [
      intel-undervolt
    ];
  };
}
