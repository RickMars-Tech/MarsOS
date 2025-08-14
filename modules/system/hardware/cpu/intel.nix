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
    boot = {
      kernelParams = [
        "intel_pstate=enable"
        "intel_idle.max_cstate=2" # Mejor balance rendimiento/energía
        "intel_iommu=on"
      ];
    };
    services.throttled.enable = true;

    environment.systemPackages = with pkgs; [
      intel-undervolt
    ];
  };
}
