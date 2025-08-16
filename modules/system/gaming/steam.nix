{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  gaming = config.mars.gaming;
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

  config =
    # let
    #   gaming = config.mars.gaming;
    # in
    {
      #==> Steam <==#
      programs = mkIf (gaming.enable && gaming.steam.enable) {
        steam = {
          enable = true;
          remotePlay.openFirewall = gaming.steam.openFirewall; # Open(or Not) ports in the firewall for Steam Remote Play
          dedicatedServer.openFirewall = gaming.steam.openFirewall; # Open ports in the firewall for Source Dedicated Server
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
        gamescope = mkIf (gaming.enable && gaming.gamescope.enable) {
          enable = true;
          package = pkgs.gamescope;
          capSysNice = true;
        };
      };
      #= Enable/Disable Steam Hardware Udev Rules.
      hardware.steam-hardware.enable = gaming.steam.hardware-rules;

      environment.systemPackages = with pkgs;
        mkIf (gaming.enable && gaming.steam.enable) [
          steam-run
          protontricks
          protonplus
        ];
    };
}
