{
  config,
  pkgs,
  lib,
  ...
}: let
  GeForceInfinity = pkgs.callPackage ../../../pkgs/geforce-infinity/default.nix {};
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
      #= Game Launchers
      lutris
      heroic

      #= Gaming utilities
      # mangohud
      # goverlay
      wireshark #= Network analysis for gaming
      pkgsi686Linux.gperftools #= Required to run CS:Source
    ];
  };
}
