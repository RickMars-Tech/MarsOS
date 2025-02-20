{pkgs, ...}: let
  gfnElectron = pkgs.callPackage ./geforce-now.nix {};
in {
  environment.systemPackages = with pkgs; [
    #= Nintendo Emulators
    #dolphin-emu # Gamecube/Wii/Triforce emulator for x86_64
    #= Ocarina of Time (PC port).
    #shipwright
    #= Super Mario 64 (PC port).
    #sm64ex
    #= GeforceNow Electron
    gfnElectron
    #= The best Game in the World
    superTuxKart
    #= FPS Game like Quake
    xonotic
    #= Steam Utils
    winetricks
    protontricks
    protonup-qt
    #= Lutris
    lutris
    #= Launcher for Veloren.
    airshipper
    #= Required to run CS:Source
    #pkgsi686Linux.gperftools
  ];
}
