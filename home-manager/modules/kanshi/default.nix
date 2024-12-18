{ config, ... }: {

    services.kanshi = {
        enable = config.programs.niri.enable;
        systemTarget = "niri-session.target";
        settings = {
            profile.name = "undockede";
            profile.outputs = {
                criteria = "LVDS-1";
                scale = 1.0;
                status = "enable";
                exec = "hyprlock";
            };
        };
    };

}
