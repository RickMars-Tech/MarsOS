{ pkgs, ... }: {

    programs.wlogout = {
        enable = true;
        layout = [
            {
                label = "shutdown";
                action = "systemctl poweroff";
                text = "Shutdown";
                keybind = "s";
            }
            {
                label = "reboot";
                action = "systemctl reboot";
                text = "Reboot";
                keybind = "r";
            }
            {
                label = "lock";
                action = "${pkgs.hyprlock}/bin/hyprlock";
                text = "Lock";
                keybind = "l";
            }
            {
                label = "logout";
                action = "loginctl kill-session $XDG_SESSION_ID";
                text = "Logout";
                keybind = "e";
            }
            {
                label = "hibernate";
                action = "systemctl hibernate";
                text = "Hibernate";
                keybind = "h";
            }
            {
                label = "suspend";
                action = "systemctl suspend";
                text = "Suspend";
                keybind = "u";
            }
        ];

        style = ''
        *{
            font-family: "DaddyTimeMono";
            background-image: none;
            transition: 15ms;
        }

        /** ********** Main Window ********** **/
        window {
            background-color: rgba( 14, 14, 23, 0.70); /* #1E1E2E; */
        }

        /** ********** Buttons ********** **/
        button {
            background-color: rgba( 14, 14, 23, 0.80); /* #242434; */
            color: #FFFFFF;
            border: 2px solid #282838;
            border-radius: 20px;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 35%;
        }

        button:focus, button:active, button:hover {
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
            background-color: rgba(270, 155, 255, 0.80); /* #89B4FA; */
            outline-style: none;
        }

        /* 
        ----------------------------------------------------- 
        Buttons
        -----------------------------------------------------
        */

        #lock {
            background-image: image(url("icons/lock.png"));
        }

        #logout {
            background-image: image(url("icons/logout.png"));
        }

        #shutdown {
            background-image: image(url("icons/shutdown.png"));
        }

        #reboot {
            background-image: image(url("icons/reboot.png"));
        }

        #hibernate {
            background-image: image(url("icons/hibernate.png"));
        }

        #suspend {
            background-image: image(url("icons/suspend.png"));
        }
        '';
    };

    xdg.configFile."wlogout/icons" = {
        recursive = true;
        source = ./icons;
    };

}
