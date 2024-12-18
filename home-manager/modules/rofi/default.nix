{ pkgs, ... }: {

    programs.rofi = {
        enable = true;
        terminal = "${pkgs.foot}/bin/foot";
        theme = ./themes/onedark.rasi;
        package = pkgs.rofi-wayland;
    };

    xdg.configFile = {
        #"rofi/config.rasi".source = ./config.rasi;
        "rofi/themes" = {
            recursive = true;
            source = ./themes;
        };
    };

}
