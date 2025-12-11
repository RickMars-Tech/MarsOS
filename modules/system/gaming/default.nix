{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption optionals;
  # Imports
  GeForceInfinity = pkgs.callPackage ../../../pkgs/geforce-infinity/default.nix {};
  dlss-swapper = pkgs.callPackage ../../../pkgs/gamingScripts/dlss-swapper.nix {};
  dlss-swapper-dll = pkgs.callPackage ../../../pkgs/gamingScripts/dlss-swapper-dll.nix {};
  zink-run = pkgs.callPackage ../../../pkgs/gamingScripts/zink-run.nix {};
  # Options
  asus = config.mars.asus.gamemode;
  gaming = config.mars.gaming;
  nvidiaPro = config.mars.graphics.nvidiaPro;
  nvidiaFree = config.mars.graphics.nvidiaFree;
  amd = config.mars.graphics.amd;
in {
  imports = [
    ./gamescope.nix
    ./minecraft.nix
    ./steam.nix
  ];

  options.mars.gaming = {
    enable = mkEnableOption "Gaming Config" // {default = false;};
    gamemode = {
      enable = mkEnableOption "Feral Gamemode" // {default = false;};
      nvidiaOptimizations = mkEnableOption "nVidia Gamemode (works with both Pro and Free)";
      amdOptimizations = mkEnableOption "AMD Gamemode";
    };
    extra-gaming-packages = mkEnableOption "Some Extra Games/Packages";
  };

  config = mkIf gaming.enable {
    # Validaciones
    assertions = [
      {
        assertion = !(gaming.gamemode.nvidiaOptimizations && gaming.gamemode.amdOptimizations);
        message = "Cannot enable both NVIDIA and AMD gamemode optimizations simultaneously";
      }
    ];

    hardware.uinput.enable = true;

    #=> Gamemode
    programs.gamemode = mkIf gaming.gamemode.enable {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          renice = 10;
          inhibit_screensaver = 1;
          disable_splitlock = 1;
        };

        # GPU-specific settings
        gpu =
          # AMD optimizations
          (mkIf (gaming.gamemode.amdOptimizations && amd.enable) {
            amd_performance_level = "high";
            apply_gpu_optimisations = "accept-responsibility";
          })
          # NVIDIA optimizations (both Pro and Free)
          // (mkIf (gaming.gamemode.nvidiaOptimizations && (nvidiaPro.enable || nvidiaFree.enable)) {
            apply_gpu_optimisations = "accept-responsibility";
          });

        cpu = {
          park_cores = "no";
          pin_cores = "yes";
        };

        filter.whitelist = "steam";

        # ASUS laptop profile switching
        custom = {
          start = mkIf asus.enable "${pkgs.asusctl}/bin/asusctl profile -p Turbo";
          end = mkIf asus.enable "${pkgs.asusctl}/bin/asusctl profile -p Balanced";
        };
      };
    };

    # Packages
    environment.systemPackages = with pkgs;
      [
        # Always include basic gaming tools
        mangohud # Vulkan and OpenGL overlay for monitoring
        goverlay # Graphical UI to manage overlays
        libstrangle # Frame rate limiter
        lm_sensors # Temperature monitoring
      ]
      # Extra gaming packages
      ++ optionals gaming.extra-gaming-packages [
        #= OpenGL over Vulkan script
        zink-run
        #= GGeForceNow
        GeForceInfinity
        #= Game Launcher
        heroic
        #= Wine
        bottles
        #= Gaming utilities
        wireshark # Network analysis
        pkgsi686Linux.gperftools # Required for some Source engine games
      ]
      # NVIDIA-specific tools
      ++ optionals (gaming.gamemode.nvidiaOptimizations && nvidiaPro.enable) [
        dlss-swapper
        dlss-swapper-dll
      ];
  };
}
