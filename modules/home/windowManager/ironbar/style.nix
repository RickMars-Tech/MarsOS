{config, ...}: {
  programs.ironbar.style = let
    color = config.stylix.base16Scheme;
    background = color.base00;
    backgroundLight = color.base01;
    border = color.base02;
    text = color.base05;
    textDim = color.base04;
    accent = color.base0D;
    urgent = color.base08;
  in
    /*
    css
    */
    ''
      /* -- Variables de color -- */
      @define-color color_bg ${background};
      @define-color color_bg_light ${backgroundLight};
      @define-color color_border ${border};
      @define-color color_text ${text};
      @define-color color_text_dim ${textDim};
      @define-color color_accent ${accent};
      @define-color color_urgent ${urgent};

      /* -- Estilos base -- */
      * {
        font-family: Montserrat, sans-serif;
        font-size: 13px;
        border: none;
        transition: all 0.2s ease-in-out;
      }

      box, menubar, button, label {
        background-color: transparent;
        background-image: none;
        box-shadow: none;
      }

      button, label {
        color: @color_text;
      }

      /* -- Barra principal -- */
      #bar {
        background-color: alpha(@color_bg, 0.95);
        border-bottom: 1px solid alpha(@color_border, 0.3);
        padding: 0 8px;
      }

      /* -- Botones generales -- */
      button {
        border-radius: 8px;
        padding: 4px 12px;
        margin: 0 2px;
        background-color: transparent;
      }

      button:hover {
        background-color: alpha(@color_bg_light, 0.6);
      }

      button:active {
        background-color: alpha(@color_accent, 0.2);
      }

      /* -- Tooltips (estilo GNOME) -- */
      tooltip {
        background-color: alpha(@color_bg, 0.98);
        color: @color_text;
        border: 1px solid alpha(@color_border, 0.5);
        border-radius: 8px;
        padding: 8px 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.4);
      }

      tooltip label {
        color: @color_text;
        padding: 2px;
      }

      /* -- Workspaces -- */
      .workspaces .item {
        border-radius: 8px;
        background-color: transparent;
        min-width: 30px;
      }

      .workspaces .item:hover {
        background-color: alpha(@color_bg_light, 0.5);
      }

      .workspaces .item.focused {
        background-color: alpha(@color_accent, 0.3);
        color: @color_text;
        font-weight: 600;
      }

      .workspaces .item.urgent {
        background-color: alpha(@color_urgent, 0.3);
        color: @color_urgent;
      }

      /* -- Focused window -- */
      .focused {
        font-weight: 500;
      }

      /* -- Clock -- */
      .clock {
        font-weight: 600;
        padding: 4px 16px;
        border-radius: 8px;
      }
      .clock:hover {
        background-color: alpha(@color_bg_light, 0.5);
      }

      /* -- Popup general -- */
      .popup {
        background-color: alpha(@color_bg, 0.98);
        border: 1px solid alpha(@color_border, 0.5);
        border-radius: 12px;
        padding: 16px;
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.5);
      }

      .popup box {
        background-color: transparent;
      }

      .popup label {
        background-color: transparent;
        color: @color_text;
      }

      .popup button {
        background-color: alpha(@color_bg_light, 0.4);
      }

      /* -- Popup Clock/Calendar -- */
      .popup-clock {
        min-width: 300px;
        background-color: alpha(@color_bg, 0.98);
      }

      .popup-clock box {
        background-color: transparent;
      }

      .popup-clock .calendar-clock {
        color: @color_text;
        font-size: 2.5em;
        font-weight: 300;
        padding-bottom: 12px;
        text-align: center;
        background-color: transparent;
      }

      .popup-clock .calendar {
        background-color: transparent;
        color: @color_text;
        padding: 8px;
        border-radius: 8px;
      }

      .popup-clock .calendar .header {
        padding: 12px 0;
        border-top: 1px solid alpha(@color_border, 0.3);
        font-size: 1.3em;
        font-weight: 500;
        background-color: transparent;
      }

      .popup-clock .calendar:selected {
        background-color: @color_accent;
        color: @color_bg;
        border-radius: 6px;
        font-weight: 600;
      }

      .popup-clock .calendar:indeterminate {
        color: @color_text_dim;
      }

      /* Días de la semana en el calendario */
      .popup-clock .calendar.day-name {
        color: @color_text_dim;
        font-weight: 600;
        font-size: 11px;
      }

      /* Días de otros meses */
      .popup-clock .calendar.other-month {
        color: @color_text_dim;
        opacity: 0.5;
      }

      /* Día actual */
      .popup-clock .calendar.today {
        background-color: alpha(@color_accent, 0.2);
        color: @color_accent;
        font-weight: 700;
        border-radius: 6px;
      }

      /* -- System Tray -- */
      .tray {
        margin: 0 4px;
        background-color: transparent;
      }
      .tray box {
        background-color: transparent;
      }
      .tray .item {
        border-radius: 8px;
        background-color: transparent;
      }
      .tray .item:hover {
        background-color: alpha(@color_bg_light, 0.5);
      }
      .tray .item box {
        background-color: transparent;
      }
      .tray .item image {
        background-color: transparent;
      }

      /* -- Clipboard -- */
      .clipboard {
        margin: 0 4px;
        padding: 4px 10px;
        border-radius: 8px;
      }
      .clipboard:hover {
        background-color: alpha(@color_bg_light, 0.5);
      }
      .popup-clipboard {
        min-width: 350px;
        max-height: 400px;
        background-color: alpha(@color_bg, 0.98);
      }
      .popup-clipboard box {
        background-color: transparent;
      }
      .popup-clipboard .item {
        padding: 10px;
        margin-bottom: 8px;
        border-radius: 8px;
        background-color: alpha(@color_bg_light, 0.3);
        border: 1px solid alpha(@color_border, 0.2);
      }
      .popup-clipboard .item:hover {
        background-color: alpha(@color_bg_light, 0.6);
      }
      .popup-clipboard .item label {
        background-color: transparent;
      }

      /* -- Notifications -- */
      .notifications {
        border-radius: 8px;
      }
      .notifications .count {
        font-size: 10px;
        font-weight: 700;
        background-color: @color_urgent;
        color: @color_bg;
        border-radius: 10px;
        padding: 2px 6px;
        margin-left: 6px;
        min-width: 18px;
        text-align: center;
      }

      /* -- Volume -- */
      .volume {
        margin: 0 4px;
        padding: 4px 10px;
        border-radius: 8px;
        min-width: 40px;
      }
      .volume:hover {
        background-color: alpha(@color_bg_light, 0.5);
      }
      .popup-volume {
        min-width: 320px;
        background-color: alpha(@color_bg, 0.98);
      }
      .popup-volume box {
        background-color: transparent;
      }
      .popup-volume label {
        background-color: transparent;
        color: @color_text;
        margin-bottom: 8px;
      }
      .popup-volume scale {
        margin: 12px 0;
      }
      .popup-volume scale trough {
        min-height: 6px;
        min-width: 200px;
        border-radius: 3px;
        background-color: alpha(@color_border, 0.5);
      }
      .popup-volume scale highlight {
        background-color: @color_accent;
        border-radius: 3px;
      }
      .popup-volume scale slider {
        min-width: 16px;
        min-height: 16px;
        border-radius: 8px;
        background-color: @color_text;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
      }
      .popup-volume scale slider:hover {
        background-color: @color_accent;
      }
      .popup-volume .device-box {
        border-right: 1px solid alpha(@color_border, 0.3);
        padding-right: 12px;
        margin-right: 12px;
        background-color: transparent;
      }
      .popup-volume button {
        background-color: alpha(@color_bg_light, 0.4);
        border-radius: 8px;
        padding: 8px 12px;
        margin: 4px 0;
      }
      .popup-volume button:hover {
        background-color: alpha(@color_bg_light, 0.7);
      }
      .popup-volume button label {
        background-color: transparent;
      }

      /* -- Battery -- */
      .battery {
        margin: 0 4px;
        padding: 4px 10px;
        border-radius: 8px;
      }
      .battery:hover {
        background-color: alpha(@color_bg_light, 0.5);
      }
      .battery.warning {
        color: @color_urgent;
      }
      .battery.critical {
        background-color: alpha(@color_urgent, 0.3);
        color: @color_urgent;
        font-weight: 600;
      }

      /* -- Bluetooth -- */
      .popup-bluetooth {
        min-height: 300px;
        min-width: 350px;
        background-color: alpha(@color_bg, 0.98);
      }
      .popup-bluetooth box {
        background-color: transparent;
      }
      .popup-bluetooth .header {
        padding-bottom: 12px;
        margin-bottom: 12px;
        border-bottom: 1px solid alpha(@color_border, 0.3);
        font-weight: 600;
        background-color: transparent;
      }
      .popup-bluetooth .header label {
        background-color: transparent;
      }
      .popup-bluetooth .devices .device {
        margin-bottom: 8px;
        padding: 10px;
        border-radius: 8px;
        background-color: alpha(@color_bg_light, 0.3);
      }
      .popup-bluetooth .devices .device:hover {
        background-color: alpha(@color_bg_light, 0.6);
      }
      .popup-bluetooth .devices .device box {
        background-color: transparent;
      }
      .popup-bluetooth .devices .device label {
        background-color: transparent;
      }
      .popup-bluetooth .devices .icon {
        min-width: 32px;
        min-height: 32px;
        margin-right: 12px;
        background-color: transparent;
      }

      /* -- Sliders generales -- */
      scale trough {
        min-height: 6px;
        border-radius: 3px;
        background-color: alpha(@color_border, 0.5);
      }

      scale highlight {
        background-color: @color_accent;
        border-radius: 3px;
      }

      scale slider {
        min-width: 14px;
        min-height: 14px;
        border-radius: 7px;
        background-color: @color_text;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      }

      scale slider:hover {
        background-color: @color_accent;
      }

      /* -- Scrollbars -- */
      scrollbar {
        background-color: transparent;
      }

      scrollbar slider {
        background-color: alpha(@color_border, 0.5);
        border-radius: 8px;
        min-width: 8px;
      }

      scrollbar slider:hover {
        background-color: alpha(@color_border, 0.7);
      }
    '';
}
