#|==< Configuration for Thinkpad T420(Intel Laptop) >==|#
_: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ../../system/default.nix
  ];

  # Hostname
  networking.hostName = "boltz";

  #= MarsOptions
  mars = {
    thinkpad.enable = true;
    power-management = {
      enable = true;
      profile = "laptop";
      cpuGovernor = "ondemand";
      enableThermalManagement = true;
      laptop = {
        enableBatteryOptimization = true;
        suspendMethod = "hybrid-sleep";
        wakeOnLid = false;
      };
    };
    cpu.intel.enable = true;
    graphics = {
      enable = true;
      intel = {
        enable = true;
        vulkan = false;
        generation = "hd";
      };
    };
    gaming = {
      enable = true;
      minecraft = {
        prismlauncher.enable = true;
        java.enable = true;
      };
      steam = {
        enable = true;
        openFirewall = false;
        hardware-rules = true;
      };
      extra-gaming-packages = true;
    };
  };

  system.stateVersion = "25.11";
}
