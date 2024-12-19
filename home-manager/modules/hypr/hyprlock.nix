{ ... }: {

    programs.hyprlock = {
        enable = true;
        sourceFirst = true;
        settings = {
            general = {
                disable_loading_bar = true;
                hide_cursor = true;
            };
            background = {
                path = "~/wal/alone.png";
                blur_size = 4;
                blur_passes = 3;
                noise = 0.0117;
                contrast = 1.3000;
                brightness = 0.8000;
                vibrancy = 0.21000;
                vibrancy_darkness = 0.0;
            };
            input-field = [
                {
                    monitor = "";
                    size = "250, 50";
                    outline_thickness = 3;

                    dots_size = 0.33;
                    dots_spacing = 0.15;
                    dots_center = true;
                    dots_rouding = -1;

                    rounding = 4;
                    outer_color = "rgb(11111b)";
                    inner_color = "rgb(11111b)";
                    font_color = "rgb(cdd6f4)";
                    fade_on_empty = true;
                    placeholder_text = "<i>Password...</i> ";

                    position = "0, -200";
                    haling = "bottom";
                    valing = "center";
                }
            ];
            label = [
                {
                    monitor = "";
                    text = ''cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"'';
                    color = "rgb(cba6f7)";
                    font_size = 64;
                    font_family = "DaddyTimeMono";
                    position = "0, 100";
                    halign = "center";
                    valign = "center";
                }
                # Type to unlock
                {
                    monitor = "";
                    text = "Type to unlock!";
                    color = "rgb(cdd6f4)";
                    font_size = 16;
                    font_family = "DaddyTimeMono";
                    position = "0, 30";
                    halign = "center";
                    valign = "bottom";
                }
            ];
        };
    };

}
