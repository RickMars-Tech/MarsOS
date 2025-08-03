{
  config,
  pkgs,
  lib,
  ...
}: {
  options.mars.gaming = {
    steam = {
      enable = lib.mkEnableOption "Enable Steam";
      openFirewall = lib.mkEnableOption "Open Ports of Firewall dedicated for Steam";
      hardware-rules = lib.mkEnableOption "Steam Hardware Udev Rules";
    };
    gamescope = {
      enable = lib.mkEnableOption "Enable Gamescope";
    };
  };

  config = let
    cfg = config.mars.gaming;
  in {
    #==> Steam <==#
    programs = {
      steam = {
        enable = cfg.enable && cfg.steam.enable;
        remotePlay.openFirewall = cfg.steam.openFirewall; # Open(or Not) ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = cfg.steam.openFirewall; # Open ports in the firewall for Source Dedicated Server
        extest.enable = false; # Do not use this option, an environment variable has already been set that works best.
        protontricks.enable = true;
        package = pkgs.steam.override {
          extraPkgs = pkgs:
            with pkgs; [
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
      gamescope = {
        enable = cfg.enable && cfg.gamescope.enable; # The T420 dont have support for Vulkan :C
        package = pkgs.gamescope;
        capSysNice = true;
      };
    };
    #= Enable/Disable Steam Hardware Udev Rules.
    hardware.steam-hardware.enable =
      if cfg.steam.hardware-rules == true
      then true
      else lib.mkForce;

    environment.systemPackages = with pkgs; [
      # adwsteamgtk
      steam-run
      protontricks
      protonplus
      # protonup-qt
    ];
  };
}
