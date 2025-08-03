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
        # "intel_pstate=enable"
        # "intel_idle.max_cstate=2" # Mejor balance rendimiento/energía
        # "intel_iommu=on"
      ];
    };
    services = {
      throttled = {
        enable = true;
        extraConfig = "";
      };
      tlp.settings = {
        # CPU.
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 70;

        # GPU
        INTEL_GPU_MIN_FREQ_ON_AC = 650;
        INTEL_GPU_MIN_FREQ_ON_BAT = 650;
        INTEL_GPU_MAX_FREQ_ON_AC = 1300;
        INTEL_GPU_MAX_FREQ_ON_BAT = 900;
        INTEL_GPU_BOOST_FREQ_ON_AC = 1300;
        INTEL_GPU_BOOST_FREQ_ON_BAT = 900;

        # Runtime Power Management and ASPM.
        RUNTIME_PM_ON_AC = "auto";
        RUNTIME_PM_ON_BAT = "auto";
        RUNTIME_PM_DRIVER_DENYLIST = "mei_me";
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "default";

        # Wifi
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";

        # ACPI
        #NATACPI_ENABLE = 1;
        TPSMAPI_ENABLE = 1;

        # MEM Sleep
        MEM_SLEEP_ON_AC = "s2idle";
        MEM_SLEEP_ON_BAT = "deep";

        # Drive Bay
        BAY_POWEROFF_ON_AC = 0;
        BAY_POWEROFF_ON_BAT = 0;

        # NMI_Watchdog
        NMI_WATCHDOG = 0;
      };
    };
    environment.systemPackages = with pkgs; [
      intel-undervolt
    ];
  };
}
