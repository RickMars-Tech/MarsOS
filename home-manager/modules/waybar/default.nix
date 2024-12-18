{ ... }: {

    programs.waybar = {
        enable = true;
        settings = {
            mainBar = {
                layer = "top";
                position = "top"; #"bottom";
                exclusive = true;

                "modules-left" = [ "custom/nix" "niri/workspaces" "niri/window" ];
                "modules-center" = [ "clock" ];
                "modules-right" = [ "gamemode" "tray" "cpu" "memory" "battery" "temperature" "backlight" "wireplumber" "network" ];

                ##--------------------------
                ## Workspaces
                ##--------------------------
                "niri/workspaces" = {
                    "format" = "{}";
                    "format-icons" = {
                        "active" = "󰮯";
                        "default" = "󰊠";
                    };
                };

                "niri/window" = {
                    "format" = "{}";
                };

                "custom/nix" = {
                    "format" = " ";
                    "tooltip" = false;
                };

                ##--------------------------
                ## Wireplumber
                ##--------------------------
                "wireplumber" = {
                    "format" = "{volume}% {icon}";
                    "format-icons" = [ "" "" ""];
                    "on-click" = "wpctl";
                };

                ##--------------------------
                ## Brightnessctl
                ##--------------------------
                "backlight" = {
                    "format" = "{percent}% {icon}";
                    "format-icons" = ["󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠"];
                    "on-click" = "brightnessctl";
                };

                ##--------------------------
                ## Gamemode
                ##--------------------------
                "gamemode" = {
                    "format" = "{glyph}";
                    "format-alt" = "{glyph} {count}";
                    "glyph" = "";
                    "hide-not-running" = true;
                    "use-icon" = true;
                    "icon" = "nf-fa-gamepad";
                    "icon-spacing" = 4;
                    "icon-size" = 20;
                };

                ##--------------------------
                ## Tray
                ##--------------------------
                "tray" = {
                    "icon-size" = 20;
                    "spacing" = 10;
                };

                ##--------------------------
                ## CPU
                ##--------------------------
                "cpu" = {
                    "interval" = 5;
                    "tooltip" = false;
                    "format" = "{usage}% ";
                    "format-alt" = "{load} ";
                    "states" = {
                        "warning" = 70;
                        "critical" = 90;
                    };
                };

                ##--------------------------
                ## RAM
                ##--------------------------
                "memory" = {
                    "interval" = 5;
                    "format" = "{}%  ";
                    "format-alt" = "{used:0.1f}/{total:0.1f}G  ";
                    "states" = {
                        "warning" = 70;
                        "critical" = 90;
                    };
                    "tooltip" = false;
                };

                ##--------------------------
                ## Network
                ##--------------------------
                "network" = {
                    "interval" = 5;
                    "format-wifi" = "Connected 󰤨 ";
                    "format-ethernet" = "{essid} 󰈀";
                    "format-disconnected" = "󰤮";
                    "format-alt" = "{bandwidthTotalBytes} 󰈀";
                    "tooltip" = false;
                };

                "bluetooth" = {
                    "format" = " {status}";
                    "format-connected" = " {device_alias}";
                    "format-connected-battery" = " {device_alias} {device_battery_percentage}%";
                    "format-device-preference" = [ "device1" "device2" ]; # preference list deciding the displayed device
                    "tooltip-format" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
                    "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
	                "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
                    "tooltip-format-enumerate-connected-battery" = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
                };

                ##--------------------------
                ## Clock
                ##--------------------------
                "clock" = {
                    "format" = " {:%I:%M}";
                    "format-alt" = " {:%d/%m/%y}";
                    "tooltip" = "true";
                    "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                };

                ##--------------------------
                ## Temperature
                ##--------------------------
                "temperature" = {
                    "critical-threshold" = 90;
                    "interval" = 5;
                    "format" = "{temperatureC}° {icon}";
                    "format-icons" = [
                        ""
                        ""
                        ""
                        ""
                        ""
                    ];
                    "tooltip" = false;
                };

                ##--------------------------
                ## Battery
                ##--------------------------
                "battery" = {
                    "interval" = 2;
                    "states" = {
                        "good" = 95;
                        "warning" = 30;
                        "critical" = 15;
                    };
                    "format" = "{icon}  {capacity}%";
                    "format-charging" = "󰂄 {capacity}%";
                    "format-plugged" = " {capacity}%";
                    "format-alt" = "{icon} ({time}Hrs)";
                    "format-icons" = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
                };
            };
        };
    };

    xdg.configFile."waybar/style.css".source = ./style.css;

}
