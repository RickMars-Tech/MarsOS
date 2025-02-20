{
  pkgs,
  lib,
  ...
}: {
  #=> Steam <=#
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      extest.enable = false; # Do not use this option, an environment variable has already been set that works best.
      #protontricks.enable = true;
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
      enable = false; # The T420 dont have support for Vulkan :C
      package = pkgs.gamescope;
      capSysNice = true;
    };
  };
  #= Enable/Disable Steam Hardware Udev Rules.
  hardware.steam-hardware.enable = lib.mkDefault false;

  #= GTK Theme for Steam.
  environment.systemPackages = with pkgs; [
    adwsteamgtk
  ];
}
