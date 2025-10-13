#|==< Thinkpad T420(Intel) >==|#
_: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ../../modules/system/default.nix
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
  };

  #|==< Mars Gaming Config >==|#
  # The reason of this is separete configs from gaming and workstation...
  # diferent boot options on the Boot Loader, and if you want one of boot...
  # just select one.
  specialisation."gaming" = {
    inheritParentConfig = true;
    configuration = {
      mars.gaming = {
        enable = true;
        gamemode = {
          enable = true;
          amdOptimizations = false;
          nvidiaOptimizations = false;
        };
        minecraft = {
          prismlauncher.enable = true;
          extraJavaPackages.enable = true;
        };
        steam = {
          enable = true;
          openFirewall = false;
          hardware-rules = true;
        };
        extra-gaming-packages = true;
      };
    };
  };

  system.stateVersion = "25.11";
}
