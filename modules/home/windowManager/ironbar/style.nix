{config, ...}: {
  programs.ironbar.style = let
    color = config.stylix.base16Scheme;
    font = config.stylix.fonts.sansSerif.name;
    background = color.base00;
    # focused = color.base0B;
    urgent = color.base08;
    # gray = color.base01;
    white = color.base05;
    purple = color.base0C;
    pink = color.base0E;
    # pink_2 = color.base09;
    # blue = color.base0A;
    # borderSize = "1px";
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

      button, label {
        box-shadow: none;
        background: none;
        background-color: rgba(0, 0, 0, 0);
      }

      .bar {
        border-top: 1px solid ${background};
      }

      .background {
        background-color: ${background};
      }

      .popup {
        border: 1px solid ${pink};
        padding: 1em;
      }

      /* -- Workspaces -- */
      .workspaces {
        background-color: ${background};
        border-radius: 100%;
        padding-left: 5px;
        padding-right: 5px;
      }
      .workspaces .item {
        border-radius: 20%;
        transition: all 0.5s;
        transition-timing-function: ease;
      }

      .workspaces .item:not(:nth-child(1)){
        margin-left: 4px;
      }

      .workspaces .item.focused,
      .workspaces .item:hover {
        color: ${pink};
      }

      .workspaces .item.urgent {
        color: ${urgent};
      }

      /* -- Clock -- */
      .clock {
        background-color: ${background};
        font-weight: bold;
        border-radius: 100%;
        padding-left: 5px;
        padding-right: 5px;
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
        background-color: ${background};
        color: ${purple};
      }

      .popup-clock .calendar-clock {
        background-color: ${background};
        font-size: 16px;
        font-weight: bold;
        border-radius: 100%;
        padding-left: 5px;
        padding-right: 5px;
      }

      .popup-clock .calendar {
        background-color: ${background};
        color: ${white};
        padding: 0.2em 0.4em;
      }

      /* -- Tray -- */
      .tray {
        border-radius: 100%;
        padding-left: 5px;
        padding-right: 5px;
        background-color: ${background};
      }

      /* -- Clipboard -- */
      .clipboard {
        background-color: ${background};
        border-radius: 100%;
        padding-left: 5px;
        padding-right: 5px;
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
      .notifications .count {
        background-color: ${background};
        color: ${white};
        padding-left: 5px;
        padding-right: 5px;
      }

      /* -- Volume -- */
      .volume {
        background-color: ${background};
        border-radius: 100%;
        padding-left: 5px;
        padding-right: 5px;

      }
      .popup-volume .device-box .device-selector {
        background-color: ${background};
      }

      .popup-volume .device-box .slider	{
        background-color: ${background};
        border-radius: 100%;
      }

      /* -- UPower / Battery -- */
      .upower {
        border-radius: 100%;
        padding-left: 10px;
        padding-right: 10px;
        color: ${white};
        background-color: ${background};
      }
      .popup-upower {
        background-color: ${background};
        color: ${white};
      }
    '';
}
