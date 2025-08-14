{config, ...}: {
  programs.ironbar.style = let
    color = config.stylix.base16Scheme;
    font = config.stylix.fonts.sansSerif.name;
    background = color.base00;
    focused = color.base0B;
    urgent = color.base08;
    # gray = color.base01;
    white = color.base05;
    purple = color.base0C;
    pink = color.base0E;
    pink_2 = color.base09;
    blue = color.base0A;
    borderSize = "1px";
  in
    /*
    css
    */
    ''
      * {
        font-family: ${font}, sans-serif;
        font-size: 14px;
        border: none;
        border-radius: 0;
      }

      .bar {
        border-top: 1px solid ${background};
      }

      .popup {
        border: 1px solid ${pink};
        padding: 1em;
      }

      /* -- Workspaces -- */
      .workspaces {
        background-color: ${background};
        margin-left: 5px;
      }

      .workspaces .item {
        background-color: ${background};
        border-radius: 20%;
      }

      .workspaces .item.focused {
        background-color: ${background};
        color: ${pink};
      }

      .workspaces .item.urgent {
        background-color: ${blue};
      }

      .workspaces .item:hover {
        background-color: ${background};
        color: ${pink};
      }

      /* -- Clock -- */
      .clock {
        background-color: ${background};
        font-weight: bold;
        margin-left: 5px;
        margin-right: 5px;
      }

      .popup-clock {
        background-color: ${background};
        font-size: 2.5em;
        margin-bottom: 5px;
        padding-left: 5px;
        padding-right: 5px;
        color: ${white};
      }

      .popup-clock .calendar:selected {
        color: ${purple};
      }

      .popup-clock .calendar-clock {
        font-size: 16px;
        font-weight: bold;
        color: ${focused};
        margin-bottom: 5px;
        padding-bottom: 0.1em;
      }

      .popup-clock .calendar {
        background-color: ${background};
        color: ${white};
        padding: 0.2em 0.4em;
      }

      /* -- Tray -- */
      .tray {
        background-color: ${background};
      }

      /* -- Clipboard -- */
      .clipboard {
        background-color: ${background};
        margin-left: 5px;
        font-size: 1.1em;
      }
      .popup-clipboard {
        background-color: ${background};
      }
      .popup-clipboard .item {
        background-color: ${background};
        padding-bottom: 0.3em;
        border-bottom: 1px solid ${purple};
      }

      /* -- Notifications -- */
      .notifications {
        background-color: ${background};
      }
      .notifications .count {
        background-color: ${background};
      }

      /* -- Volume -- */
      .volume {
        background-color: ${background};
        margin-left: 5px;
      }
      .popup-volume .device-box .device-selector {
        background-color: ${background};
      }

      .popup-volume .device-box .slider	{
        background-color: ${background};
      }

      /* -- UPower / Battery -- */
      .upower {
        background-color: ${background};
      }
      .popup-upower {
        background-color: ${background};
        color: ${white};
      }
    '';
}
