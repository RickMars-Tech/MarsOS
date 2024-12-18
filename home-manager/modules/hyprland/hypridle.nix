{ pkgs, ...}: {

    services.hypridle = {
        enable = true;
        settings = {
            general = {
                after_sleep_cmd = "hyprctl dispatch dpms on";
                ignore_dbus_inhibit = false;
                lock_cmd = "hyprlock";
            };

            listener = [
                {
                    timeout = 600;
                    on-timeout = "${pkgs.hyprlock}/bin/hyprlock";
                    on-resume = ''${pkgs.libnotify}/bin/notify-send "Welcome back!"'';
                }
                {
                    timeout = 600;
                    on-timeout = "hyprctl dispatch dpms off";
                    on-resume = "hyprctl dispatch dpms on";
                }
            ];
        };
    };

}
