{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  options.mars.gaming = {
    steam = {
      enable = mkEnableOption "Enable Steam";
      openFirewall = mkEnableOption "Open Ports of Firewall dedicated for Steam";
      hardware-rules = mkEnableOption "Steam Hardware Udev Rules";
    };
    gamescope = {
      enable = mkEnableOption "Enable Gamescope";
    };
  };

  config = let
    cfg = config.mars.gaming;
  in {
    #==> Steam <==#
    programs = mkIf (cfg.enable && cfg.steam.enable) {
      steam = {
        enable = true;
        remotePlay.openFirewall = cfg.steam.openFirewall; # Open(or Not) ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = cfg.steam.openFirewall; # Open ports in the firewall for Source Dedicated Server
        extest.enable = false; # Do not use this option, an environment variable has already been set that works best.
        protontricks.enable = true;
        package = pkgs.steam.override {
          extraPkgs = pkgs:
            with pkgs; [
              SDL2
              libjpeg
              openal
              mono
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              libkrb5
              stdenv.cc.cc.lib
              keyutils
            ];
        };
      };
      #=> Gamescope <=#
      gamescope = mkIf (cfg.enable && cfg.gamescope.enable) {
        enable = true;
        package = pkgs.gamescope;
        capSysNice = true;
      };
    };
    #= Enable/Disable Steam Hardware Udev Rules.
    hardware.steam-hardware.enable = cfg.steam.hardware-rules;

    environment.systemPackages = with pkgs;
      mkIf (cfg.enable && cfg.steam.enable) [
        steam-run
        protontricks
        protonplus
      ];
  };
}
