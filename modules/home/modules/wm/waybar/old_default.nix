{...}: let
  waybarSettings = [
    {
      layer = "top";
      position = "bottom"; # "top";
      exclusive = true;

      "modules-left" = [
        "clock"
        "niri/workspaces"
      ];
      "modules-center" = ["niri/window"];
      "modules-right" = [
        "gamemode"
        "tray"
        "battery"
        "temperature"
        "backlight"
        "wireplumber"
        "network"
      ];

      ##--------------------------
      ## Workspaces
      ##--------------------------

      "niri/workspaces" = {
        "on-click" = "activate";
        "all-outputs" = false;
        "active-only" = false;
        "format" = "{icon}";
        "format-icons" = {
          "default" = "";
          "active" = "";
        };
      };

      "niri/window" = {
        "icon" = true;
      };

      "custom/nix" = {
        "format" = "  ";
        "tooltip" = false;
      };

      ##--------------------------
      ## Wireplumber
      ##--------------------------
      "wireplumber" = {
        "format" = "{icon} {volume}%";
        "format-icons" = [
          ""
          ""
          ""
        ];
        "on-click" = "pwvucontrol";
      };

      ##--------------------------
      ## Brightnessctl
      ##--------------------------
      "backlight" = {
        "format" = "{icon} {percent}%";
        "format-icons" = [
          "󱩎"
          "󱩏"
          "󱩐"
          "󱩑"
          "󱩒"
          "󱩓"
          "󱩔"
          "󱩕"
          "󱩖"
          "󰛨"
        ];
        "on-click" = "brightnessctl";
      };

      ##--------------------------
      ## Gamemode
      ##--------------------------
      "gamemode" = {
        "format" = "{glyph}";
        "format-alt" = "{glyph} {count}";
        "glyph" = "󰊴";
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
        "reverse-direction" = true;
        "spacing" = 4;
      };

      ##--------------------------
      ## CPU
      ##--------------------------
      "cpu" = {
        "interval" = 5;
        "tooltip" = false;
        "format" = " {usage}%";
        "format-alt" = " {load}";
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
        "format" = " {}%";
        "format-alt" = " {used:0.1f}/{total:0.1f}G";
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
        "format-wifi" = "{icon}Conectado";
        "format-ethernet" = " 󰈀 ";
        "format-disconnected" = " 󰤮 ";
        "format-alt" = "󰈀 {bandwidthTotalBytes}";
        "format-icons" = [
          "󰤯 "
          "󰤟 "
          "󰤢 "
          "󰤥 "
          "󰤨 "
        ];
        "tooltip" = false;
      };

      ##--------------------------
      ## Clock
      ##--------------------------
      "clock" = {
        "format" = "  {:%I:%M}";
        "format-alt" = "  {:%d/%m/%y}";
        "tooltip" = "true";
        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      ##--------------------------
      ## Temperature
      ##--------------------------
      "temperature" = {
        "critical-threshold" = 90;
        "interval" = 5;
        "format" = "{icon}{temperatureC}°";
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
        "format" = "{icon} {capacity}%";
        "format-charging" = " 󰂄 {capacity}%";
        "format-plugged" = "  {capacity}%";
        "format-alt" = "{icon} ({time}Hrs)";
        "format-icons" = [
          "󰂎"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
      };
    }
  ];
in {
  programs.waybar = {
    enable = true;

    settings = waybarSettings;
  };
}
