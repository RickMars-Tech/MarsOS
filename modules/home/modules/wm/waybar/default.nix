{
  config,
  pkgs,
  ...
}: let
  waybarSettings = [
    {
      layer = "top";
      position = "top";
      modules-left = [
        "custom/startmenu"
        "custom/arrow6"
        "pulseaudio"
        "custom/arrow-sep2"
        "cpu"
        "custom/arrow-sep2"
        "memory"
        "custom/arrow-sep2"
        "idle_inhibitor"
        "custom/arrow7"
        "niri/window"
      ];
      modules-center = ["niri/workspaces"];
      modules-right = [
        "tray"
        # "custom/arrow4"
        # "custom/exit"
        #"custom/arrow3"
        "custom/arrow-sep1"
        "battery"
        "custom/arrow-sep1"
        "network"
        "custom/arrow2"
        "clock"
        "custom/arrow1"
        "custom/exit"
      ];

      ##--------------------------
      ## Niri
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
        max-length = 22;
        separate-outputs = false;
        rewrite = {
          "" = " 🙈 No Windows? ";
        };
      };

      ##--------------------------
      ## Clock
      ##--------------------------
      "clock" = {
        format = "  {:%I:%M}";
        format-alt = "  {:%d/%m/%y}";
        tooltip = true;
        tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
      };

      ##--------------------------
      ## Metrics
      ##--------------------------
      "memory" = {
        interval = 5;
        format = " {}%";
        tooltip = true;
      };
      "cpu" = {
        interval = 5;
        format = "{usage:2}%";
        tooltip = true;
      };
      "disk" = {
        format = " {free}";
        tooltip = true;
      };
      ##--------------------------
      ## Network
      ##--------------------------
      "network" = {
        "interval" = 5;
        "format-wifi" = "{icon}{signalStrength}%";
        "format-ethernet" = "󰈀 {bandwidthDownOctets}";
        "format-disconnected" = " 󰤮 ";
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
      ## Tray
      ##--------------------------
      "tray" = {
        spacing = 12;
      };
      ##--------------------------
      ## Pulseaudio
      ##--------------------------
      "pulseaudio" = {
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "󰂑";
          headset = "󰂑";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
        };
        on-click = "sleep 0.1 && pavucontrol";
      };
      ##--------------------------
      ## Exit
      ##--------------------------
      "custom/exit" = {
        tooltip = false;
        format = "";
        on-click = "sleep 0.1 && wlogout";
      };
      ##--------------------------
      ## StartMenu
      ##--------------------------
      "custom/startmenu" = {
        tooltip = false;
        format = "";
        on-click = "sleep 0.1 && fuzzel";
      };
      ##--------------------------
      ## Idle
      ##--------------------------
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
        tooltip = "true";
      };
      ##--------------------------
      ## Battery
      ##--------------------------
      "battery" = {
        states = {
          good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = "󱘖 {capacity}%";
        format-icons = [
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
        tooltip = false;
      };
      ##--------------------------
      ## Arrows
      ##--------------------------
      "custom/arrow-sep1" = {
        format = "";
      };
      "custom/arrow-sep2" = {
        format = "";
      };
      "custom/arrow1" = {
        format = "";
      };
      "custom/arrow2" = {
        format = "";
      };
      "custom/arrow3" = {
        format = "";
      };
      "custom/arrow4" = {
        format = "";
      };
      "custom/arrow5" = {
        format = "";
      };
      "custom/arrow6" = {
        format = "";
      };
      "custom/arrow7" = {
        format = "";
      };
    }
  ];

  waybarStyle = "
      * {
        font-family: FiraCode Nerd Font Propo;
        font-size: 14px;
        border-radius: 0px;
        border: none;
        min-height: 0px;
      }
      window#waybar {
        background: #${config.lib.stylix.colors.base00};
        color: #${config.lib.stylix.colors.base05};
      }
      #workspaces button {
        padding: 0px 5px;
        background: transparent;
        color: #${config.lib.stylix.colors.base04};
      }
      #workspaces button.active {
        color: #${config.lib.stylix.colors.base08};
      }
      #workspaces button:hover {
        color: #${config.lib.stylix.colors.base08};
      }
      tooltip {
        background: #${config.lib.stylix.colors.base00};
        border: 1px solid #${config.lib.stylix.colors.base05};
        border-radius: 12px;
      }
      tooltip label {
        color: #${config.lib.stylix.colors.base05};
      }
      #window {
        padding: 0px 10px;
      }
      #wireplumber, #pulseaudio, #cpu, #memory, #idle_inhibitor {
        padding: 0px 10px;
        background: #${config.lib.stylix.colors.base04};
        color: #${config.lib.stylix.colors.base00};
      }
      #custom-startmenu {
        color: #${config.lib.stylix.colors.base02};
        padding: 0px 14px;
        font-size: 20px;
        background: #${config.lib.stylix.colors.base0B};
      }
      #custom-notification, #custom-exit {
        background: #${config.lib.stylix.colors.base0F};
        color: #${config.lib.stylix.colors.base00};
        padding: 0px 10px;
      }
      #tray {
        background: #${config.lib.stylix.colors.base00};
        color: #${config.lib.stylix.colors.base00};
        padding: 0px 10px;
      }
      #clock {
        font-weight: bold;
        padding: 0px 10px;
        color: #${config.lib.stylix.colors.base00};
        background: #${config.lib.stylix.colors.base0E};
      }
      #custom-arrow-sep1 {
        font-size: 24px;
        color: #${config.lib.stylix.colors.base0F};
        background: #${config.lib.stylix.colors.base00};
      }
      #custom-arrow-sep2 {
        font-size: 24px;
        color: #${config.lib.stylix.colors.base00};
        background: #${config.lib.stylix.colors.base04};
      }
      #custom-arrow1 {
        font-size: 24px;
        color: #${config.lib.stylix.colors.base0F};
        background: #${config.lib.stylix.colors.base0E};
      }
      #custom-arrow2 {
        font-size: 24px;
        color: #${config.lib.stylix.colors.base0E};
        background: #${config.lib.stylix.colors.base00};
      }
      #custom-arrow3 {
        font-size: 24px;
        color: #${config.lib.stylix.colors.base00};
        background: #${config.lib.stylix.colors.base0F};
      }
      #custom-arrow4 {
        font-size: 24px;
        color: #${config.lib.stylix.colors.base0F};
        background: transparent;
      }
      #custom-arrow6 {
        font-size: 24px;
        color: #${config.lib.stylix.colors.base0B};
        background: #${config.lib.stylix.colors.base04};
      }
      #custom-arrow7 {
        font-size: 24px;
        color: #${config.lib.stylix.colors.base04};
        background: transparent;
      }
    ";
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = waybarSettings;
    style = waybarStyle;
  };
}
