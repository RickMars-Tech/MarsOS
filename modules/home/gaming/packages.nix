{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;
  # Imports
  GeForceInfinity = pkgs.callPackage ../../../pkgs/geforce-infinity/default.nix {};
  dlss-swapper = pkgs.callPackage ../../../pkgs/gamingScripts/dlss-swapper.nix {};
  dlss-swapper-dll = pkgs.callPackage ../../../pkgs/gamingScripts/dlss-swapper-dll.nix {};
  zink-run = pkgs.callPackage ../../../pkgs/gamingScripts/zink-run.nix {};
  nouveauPrimeRun = pkgs.callPackage ../../../pkgs/gamingScripts/nouveau-prime-run.nix {};

  # Options
  inherit (config.mars) gaming;
  inherit (config.mars.hardware.graphics) nvidiaPro;
  inherit (config.mars.hardware.graphics) nvidiaFree;
in {
  environment.systemPackages = with pkgs;
    [
      mangohud # Vulkan and OpenGL overlay for monitoring
      goverlay # Graphical UI to manage overlays
      libstrangle # Frame rate limiter
      lm_sensors # Temperature monitoring
      vkbasalt # Vulkan post-processing layer
      pciutils
    ]
    # Extra gaming packages
    ++ optionals gaming.extra-gaming-packages [
      #= GeForceNow
      GeForceInfinity
      #= OpenGL over Vulkan script
      zink-run
      #= Wine
      bottles
      #= Gaming utilities
    ]
    # NVIDIA-specific tools
    ++ optionals (gaming.gamemode.nvidiaOptimizations && nvidiaPro.enable) [
      dlss-swapper
      dlss-swapper-dll
    ]
    # Nouveau-specific tools
    ++ optionals (gaming.gamemode.nvidiaOptimizations && nvidiaFree.enable) [
      nouveauPrimeRun
    ];
}
