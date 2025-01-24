{ pkgs, ... }: {

    services.dbus = {
        enable = true;
        implementation = "broker"; 
        packages = with pkgs; [ 
            dunst
            flatpak
            greetd.greetd
            greetd.tuigreet
        ];
    };

}
