#|==< Asus Laptop with AMD APU + Nvidia GPU >==|#
{
  imports = [
    # Include the results of the hardware scan.
    # ./hardware.nix
    ../../modules/system/default.nix
  ];

  # Hostname
  networking.hostName = "rift";

  #|==< Mars Config >==|#
  mars = {
    boot = {
      lanzaboot = true;
      plymouth = true;
      kernel.version = "latest";
    };
    asus.enable = true;
    laptopOptimizations = true;
    cpu.amd.enable = true;
    graphics = {
      enable = true;
      #= AMD/RADEON
      amd = {
        enable = true;
        vulkan = true;
        opengl = true;
        compute.enable = false;
      };
      #= nVidia
      # nvidiaFree.enable = true; #= Broken
      nvidiaPro = {
        enable = true;
        nvenc = true;
        driver = "latest";
        compute = {
          enable = false;
          cuda = false;
          tensorrt = false;
        };
        #= Nvidia Prime Offload
        prime = {
          enable = true;
          igpu = {
            vendor = "amd";
            port = "PCI:35:0:0";
          };
          dgpu.port = "PCI:1:0:0";
        };
        wayland-fixes = true;
      };
    };
    #= Gaming
    gaming = {
      enable = true;
      gamemode = {
        enable = true;
        amdOptimizations = false;
        nvidiaOptimizations = true;
      };
      gamescope.enable = true;
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

  system.stateVersion = "25.11";
}
