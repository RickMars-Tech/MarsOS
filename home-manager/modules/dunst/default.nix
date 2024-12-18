{ pkgs, ...}: {

    services.dunst = {
        enable = true;
        iconTheme = {
            package = pkgs.cosmic-icons; #pkgs.flat-remix-icon-theme;
            name = "Cosmic"; #"Flat-Remix-Blue-Dark";
        };
        settings = {
            global = {
                frame_color = "#89b4fa";
                separator_color = "frame";
            };

            urgency_low = {
                background = "#1e1e2e";
                foreground = "#cdd6f4";
            };

            urgency_normal = {
                background = "#1e1e2e";
                foreground = "#cdd6f4";
            };

            urgency_critical = {
                background = "#1e1e2e";
                foreground = "#cdd6f4";
                frame_color = "#fab387";
            };
        };
    };

}
