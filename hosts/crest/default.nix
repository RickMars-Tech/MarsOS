#|==< Desktop PC with Integrated AMD Gpu >==|#
{
  imports = [
    ./disko.nix
    ../../modules/system/default.nix
  ];

  # Hostname
  networking.hostName = "crest";

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
