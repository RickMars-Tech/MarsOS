{ ... }: {

    programs.alacritty = {
        enable = true;
        settings = {
            env = {
                TERM = "xterm-256color";
            };
            window = {
                decorations = "None";
                blur = true;
            };
            cursor = {
              style = "block";
            };
            font = {
                normal = {
                    family = "FiraCode Nerd Font";
                    style = "Regular";
                };
                size = 12;
            };
            colors = {
                primary = {
                    background = "#1B1B28";
                    foreground = "#cdd6f4";
                    dim_foreground = "#7f849c";
                    bright_foreground = "#cdd6f4";
                };
                cursor = {
                    text = "#1B1B28";
                    cursor = "#f5e0dc";
                };
                vi_mode_cursor = {
                    text = "#1B1B28";
                    cursor = "#b4befe";
                };
                search = {
                    matches = {
                        foreground = "#1B1B28";
                        background = "#a6adc8";
                    };
                    focused_match = {
                        foreground = "#1B1B28";
                        background = "#a6e3a1";
                    };
                };
                footer_bar = {
                    foreground = "#1B1B28";
                    background = "#a6adc8";
                };
                hints = {
                    start = {
                        foreground = "#1B1B28";
                        background = "#f9e2af";
                    };
                    end = {
                        foreground = "#1B1B28";
                        background = "#a6adc8";
                    };
                };
                selection = {
                    text = "#1B1B28";
                    background = "#f5e0dc";
                };
                normal = {
                    black = "#45475a";
                    red = "#f38ba8";
                    green = "#a6e3a1";
                    yellow = "#f9e2af";
                    blue = "#89b4fa";
                    magenta = "#f5c2e7";
                    cyan = "#94e2d5";
                    white = "#bac2de";
                };
                bright = {
                    black = "#585b70";
                    red = "#f38ba8";
                    green = "#a6e3a1";
                    yellow = "#f9e2af";
                    blue = "#89b4fa";
                    magenta = "#f5c2e7";
                    cyan = "#94e2d5";
                    white = "#a6adc8";
                };
                indexed_colors = [
                    {
                        index = 16;
                        color = "#fab387";
                    }
                    {
                        index = 17;
                        color = "#f5e0dc";
                    }
                ];
                transparent_background_colors = false;
            };
        };
    };

}
