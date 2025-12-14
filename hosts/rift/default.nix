#|==< Asus Laptop with AMD APU + Nvidia GPU >==|#
{
  imports = [
    ./disko.nix
    ../../modules/system/default.nix
  ];
  # Hostname
  networking.hostName = "rift";
  #|==< Mars Config >==|#
  mars = {
    boot = {
      secureBoot = true;
      plymouth = true;
      kernel.version = "latest";
    };
    #= Enable Doas
    security.doas = true;
    #= Hardware
    asus = {
      enable = true;
      battery.chargeUpto = 80;
    };
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
      nvidiaFree.enable = false; #= It Works now but the Performance is not the best
      nvidiaPro = {
        enable = true;
        nvenc = true;
        driver = "beta";
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
    #= Desktop
    desktop.graphics = true; # include Graphics/Creation tools like OBS and Gimp
    #= Development
    dev = {
      git = {
        enable = true;
        username = "RickMars-Tech";
        email = "rickmars117@proton.me";
      };
      languages = {
        nix = true;
        python = true;
        octave = true;
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
