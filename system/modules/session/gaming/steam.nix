{ pkgs, lib, ... }: {

#=> Steam <=#
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        extest.enable = true; # For using Steam Input on Wayland
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
    #= Enable/Disable Steam Hardware Udev Rules
    hardware.steam-hardware.enable = lib.mkDefault false;

    environment.systemPackages = with pkgs; [
        adwsteamgtk
    ];

#=> Gamescope <=#
    programs.gamescope = {
        enable = true;
        package = pkgs.gamescope;
        capSysNice = true;
    };

}
