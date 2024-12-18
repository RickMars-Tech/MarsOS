{  lib, ... }: {

    services = {
        desktopManager.cosmic.enable = true;
        displayManager.cosmic-greeter.enable = lib.mkDefault true;
    };
}
