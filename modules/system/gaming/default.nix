{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  # Imports
  GeForceInfinity = pkgs.callPackage ../../../pkgs/geforce-infinity/default.nix {};
  dlss-swapper = pkgs.callPackage ../../../pkgs/gamingScripts/dlss-swapper.nix {};
  dlss-swapper-dll = pkgs.callPackage ../../../pkgs/gamingScripts/dlss-swapper-dll.nix {};
  zink-run = pkgs.callPackage ../../../pkgs/gamingScripts/zink-run.nix {};
  # Options
  asus = config.mars.asus.gamemode;
  gaming = config.mars.gaming;
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
      nvidiaOptimizations = mkEnableOption "nVidia Gamemode"; #= Configs on desktop/env.nix
      amdOptimizations = mkEnableOption "AMD Gamemode";
    };
    extra-gaming-packages = mkEnableOption "Some Extra Games/Packages";
  };

  config = mkIf gaming.enable {
    #=> Gamemode
    programs.gamemode = mkIf (gaming.enable && gaming.gamemode.enable) {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
          inhibit_screensaver = 1;
          disable_splitlock = 1;
        };
        gpu = mkIf (gaming.gamemode.amdOptimizations && gaming.enable) {
          amd_performance_level = "high";
        };
        cpu = {
          park_cores = "no";
          pin_cores = "yes";
        };
        filter.whitelist = "steam";
        custom = {
          start =
            if (asus.enable == true)
            then "${pkgs.asusctl}/bin/asusctl profile -p Turbo"
            else "";

          end =
            if (asus.enable == true)
            then "${pkgs.asusctl}/bin/asusctl profile -p Balanced"
            else "";
        };
      };
    };
    # packages
    environment.systemPackages = with pkgs;
      mkIf gaming.extra-gaming-packages [
        #= Gaming Scritps
        dlss-swapper
        dlss-swapper-dll
        zink-run
        #= GeForce Infinity
        GeForceInfinity
        #= Game Launchers
        lutris
        heroic
        #= Wine
        bottles
        #= Gaming utilities
        lm_sensors
        mangohud #= Vulkan and OpenGL overlay for monitoring PC
        goverlay #= Graphical UI to help manage Linux overlays
        libstrangle #= Frame rate limiter for Linux/OpenGL
        wireshark #= Network analysis for gaming
        pkgsi686Linux.gperftools #= Required to run CS:Source
      ];
  };
}
