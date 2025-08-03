{
  config,
  pkgs,
  lib,
  ...
}: let
  GeForceInfinity = pkgs.callPackage ../custom-packages/geforce-now/default.nix {};
in {
  options.mars.gaming.extra-gaming-packages = lib.mkEnableOption "Some Extra Games/Packages";

  config = lib.mkIf (config.mars.gaming.extra-gaming-packages) {
    environment.systemPackages = with pkgs; [
      #= GeForce Infinity
      GeForceInfinity
      #= Nintendo Emulators
      dolphin-emu # Gamecube/Wii/Triforce emulator for x86_64
      #= Ocarina of Time (PC port).
      shipwright
      #= Super Mario 64 (PC port).
      # sm64ex
      #= The best Game in the World
      superTuxKart
      #= FPS Game like Quake
      xonotic
      #= Steam Utils
      winetricks
      #= Lutris
      lutris
      #= Launcher for Veloren.
      airshipper
      #= Required to run CS:Source
      pkgsi686Linux.gperftools
    ];
  };
}
