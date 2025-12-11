{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) getExe;
  color = config.lib.stylix.colors;
  font = config.stylix.fonts.sansSerif.name;
  lock = getExe pkgs.hyprlock;
in {
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "sleep 1; systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        "label" = "reboot";
        "action" = "sleep 1; systemctl reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
      {
        "label" = "logout";
        "action" = "sleep 1; loginctl terminate-user $USER";
        "text" = "Exit";
        "keybind" = "e";
      }
      {
        "label" = "suspend";
        "action" = "sleep 1; systemctl suspend";
        "text" = "Suspend";
        "keybind" = "u";
      }
      {
        "label" = "lock";
        "action" = "${lock} &";
        "text" = "Lock";
        "keybind" = "l";
      }
      {
        "label" = "hibernate";
        "action" = "sleep 1; systemctl hibernate";
        "text" = "Hibernate";
        "keybind" = "h";
      }
    ];
    style = ''
      * {
        font-family: "${font}";
      	background-image: none;
      	transition: 20ms;
      }
      window {
      	background-color: rgba(12, 12, 12, 0.1);
      }
      button {
      	color: #${color.base05};
        font-size:20px;
        background-repeat: no-repeat;
      	background-position: center;
      	background-size: 20%;
      	border-style: solid;
        border-radius: 20px;
      	background-color: #${color.base00};
      	border: 3px solid #${color.base05};
      }
      button:focus,
      button:active,
      button:hover {
        color: #${color.base0B};
        background-color: #${color.base01};
        border: 3px solid #${color.base0B};
        outline-style: none;
      }
      #logout {
      	margin: 10px;
      	background-image: image(url("icons/logout.png"));
      }
      #suspend {
      	margin: 10px;
      	background-image: image(url("icons/suspend.png"));
      }
      #shutdown {
      	margin: 10px;
      	background-image: image(url("icons/shutdown.png"));
      }
      #reboot {
      	margin: 10px;
      	background-image: image(url("icons/reboot.png"));
      }
      #lock {
      	margin: 10px;
      	background-image: image(url("icons/lock.png"));
      }
      #hibernate {
        margin: 10px;
      	background-image: image(url("icons/hibernate.png"));
      }
    '';
  };

  xdg.configFile."wlogout/icons" = {
    recursive = true;
    source = ./icons;
  };
}
