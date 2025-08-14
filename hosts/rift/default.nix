#|==< Configuration for Asus (Ryzen + Nvidia Laptop) >==|#
_: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ../../modules/system/default.nix
  ];

  # Hostname
  networking.hostName = "rift";

  #|==< Mars Config >==|#
  mars = {
    asus.enable = true;
    power-management = {
      enable = true;
      profile = "laptop";
      cpuGovernor = "ondemand";
      enableThermalManagement = true;
    };
    cpu.amd.enable = true;
    graphics = {
      enable = true;
      hybridGPU = true;
      amd = {
        enable = true;
        vulkan = true;
        opengl = true;
        compute.enable = true;
      };
      nvidia = {
        enable = true;
        nvenc = true;
        driver = "beta";
        compute = {
          enable = true;
          cuda = true;
          tensorrt = true;
        };
        # hybrid = {
        #   enable = true;
        #   igpu = {
        #     vendor = "amd";
        #     port = null;
        #   };
        #   dgpu.port = null;
        # };
        wayland-fixes = true;
      };
    };
  };

  #|==< IMPORTANT >==|#
  # You cant diplicate configs,
  # Specialisations separate configs
  # by diferents boot loader entries
  # You cant diplicate configs,
  specialisation."gaming" = {
    inheritParentConfig = true;
    configuration = {
      mars.gaming = {
        enable = true;
        gamemode = {
          enable = true;
          amdOptimizations = false;
          nvidiaOptimizations = true;
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
