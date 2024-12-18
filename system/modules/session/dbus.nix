{ pkgs, ... }: {

    services.dbus = {
        enable = true;
        implementation = "dbus"; 
        packages = with pkgs; [ 
            dunst
            flatpak
            niri
            greetd.greetd
            greetd.tuigreet
        ];
    };

}
