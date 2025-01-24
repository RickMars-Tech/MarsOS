{ config, pkgs, lib, ... }: {

    services.throttled = {
        enable = true;
        extraConfig = "";
    };

    hardware.trackpoint = {
        enable = lib.mkDefault true;
        emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;
    };

    environment.systemPackages = with pkgs; [
        tpacpi-bat
    ];

}
