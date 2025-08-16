{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  GeForceInfinity = pkgs.callPackage ../../../pkgs/geforce-infinity/default.nix {};
  # Gaming Scripts
  dlss-swapper = pkgs.callPackage ../../../pkgs/gamingScripts/dlss-swapper.nix {};
  dlss-swapper-dll = pkgs.callPackage ../../../pkgs/gamingScripts/dlss-swapper-dll.nix {};
  zink-run = pkgs.callPackage ../../../pkgs/gamingScripts/zink-run.nix {};
in {
  options.mars.gaming.extra-gaming-packages = mkEnableOption "Some Extra Games/Packages";

  config = mkIf (config.mars.gaming.extra-gaming-packages) {
    environment.systemPackages = with pkgs; [
      #= Gaming Scritps
      dlss-swapper
      dlss-swapper-dll
      zink-run
      #= GeForce Infinity
      GeForceInfinity
      #= Nintendo Emulators
      dolphin-emu # Gamecube/Wii/Triforce emulator for x86_64
      #= Ocarina of Time (PC port).
      #shipwright
      #= The best Game in the World
      superTuxKart
      #= Launcher for Veloren.
      airshipper
      #= Game Launchers
      lutris
      heroic

      #= Gaming utilities
      powertop
      lm_sensors
      mangohud #= Vulkan and OpenGL overlay for monitoring PC
      goverlay #= Graphical UI to help manage Linux overlays
      libstrangle #= Frame rate limiter for Linux/OpenGL
      wireshark #= Network analysis for gaming
      pkgsi686Linux.gperftools #= Required to run CS:Source
    ];
  };
}
