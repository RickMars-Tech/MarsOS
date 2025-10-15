#|==< Desktop PC with Integrated AMD Gpu >==|#
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
    cpu.amd.enable = true;
    graphics = {
      enable = true;
      amd = {
        enable = true;
        vulkan = true;
        opengl = true;
        compute.enable = false;
      };
    };
    gaming = {
      enable = true;
      gamemode = {
        enable = true;
        amdOptimizations = true;
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

  system.stateVersion = "25.11";
}
