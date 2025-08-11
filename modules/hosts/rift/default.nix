#|==< Configuration for Asus Tuf A15/16Laptop (Ryzen + Nvidia Laptop) >==|#
_: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ../../system/default.nix
  ];

  # Hostname
  networking.hostName = "rift";

  #= MarsOptions
  mars = {
    asus = {
      enable = true;
      gamemode.enable = true;
    };
    power-management = {
      enable = true;
      profile = "laptop";
      cpuGovernor = "ondemand";
      enableThermalManagement = true;
      laptop = {
        enable = true;
        suspendMethod = "hybrid-sleep";
        wakeOnLid = false;
      };
    };
    cpu.amd.enable = true;
    graphics = {
      enable = true;
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
        hybrid = {
          enable = true;
          igpu = {
            vendor = "amd";
            port = null;
          };
          dgpu.port = null;
        };
        wayland-fixes = true;
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
