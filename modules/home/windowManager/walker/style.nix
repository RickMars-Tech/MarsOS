{config, ...}: {
  services.walker.theme.style = let
    color = config.stylix.base16Scheme;

    # Colores del esquema (nombres con guiones bajos)
    background = color.base00;
    background_light = color.base01;
    background_lighter = color.base02;
    foreground = color.base05;
    foreground_dim = color.base04;

    # Colores de acento
    accent_blue = color.base0A;
    accent_cyan = color.base0B;
    accent_purple = color.base0C;
    accent_pink = color.base0E;

    # Colores de estado
    error = color.base08;
    warning = color.base09;
  in
    /*
    css
    */
    ''
      /* Definición de colores basados en Stylix */
      @define-color foreground ${foreground};
      @define-color background ${background};
      @define-color background_light ${background_light};
      @define-color background_lighter ${background_lighter};
      @define-color color1 ${accent_cyan};
      @define-color accent ${accent_blue};
      @define-color error_color ${error};

      /* Reset de estilos */
      #window,
      #box,
      #aiScroll,
      #aiList,
      #search,
      #password,
      #input,
      #prompt,
      #clear,
      #typeahead,
      #list,
      #child,
      #scrollbar,
      #slider,
      #item,
      #text,
      #label,
      #bar,
      #sub,
      #activationlabel {
        all: unset;
      }

      /* Mensaje de error de configuración */
      #cfgerr {
        background: alpha(@error_color, 0.4);
        margin-top: 20px;
        padding: 8px;
        font-size: 1.2em;
        color: @foreground;
      }

      /* Ventana principal */
      #window {
        color: @foreground;
      }

      /* Contenedor principal */
      #box {
        border-radius: 8px;
        background: @background;
        padding: 32px;
        border: 1px solid @background_light;
        box-shadow:
          0 19px 38px rgba(0, 0, 0, 0.5),
          0 15px 12px rgba(0, 0, 0, 0.3);
      }

      /* Barra de búsqueda */
      #search {
        box-shadow:
          0 1px 3px rgba(0, 0, 0, 0.2),
          0 1px 2px rgba(0, 0, 0, 0.3);
        background: @background_light;
        padding: 8px;
        border-radius: 4px;
      }

      /* Prompt */
      #prompt {
        margin-left: 4px;
        margin-right: 12px;
        color: @accent;
        opacity: 0.6;
      }

      /* Botón limpiar */
      #clear {
        color: @foreground;
        opacity: 0.6;
        transition: opacity 0.2s;
      }

      #clear:hover {
        opacity: 1;
      }

      /* Campos de entrada */
      #password,
      #input,
      #typeahead {
        border-radius: 4px;
      }

      #input {
        background: none;
        color: @foreground;
      }

      #password {
        background: @background_lighter;
        padding: 4px 8px;
      }

      /* Spinner de carga */
      #spinner {
        padding: 8px;
        color: @accent;
      }

      /* Texto de autocompletado */
      #typeahead {
        color: @foreground;
        opacity: 0.5;
      }

      /* Placeholder del input */
      #input placeholder {
        opacity: 0.4;
        color: @foreground;
      }

      /* Lista de resultados */
      #list {
        margin-top: 8px;
      }

      /* Elementos de la lista */
      child {
        padding: 10px;
        border-radius: 4px;
        transition: background 0.15s ease;
      }

      child:selected,
      child:hover {
        background: alpha(@color1, 0.3);
      }

      /* Iconos */
      #icon {
        margin-right: 10px;
      }

      /* Texto del elemento */
      #label {
        font-weight: 500;
        color: @foreground;
      }

      /* Subtexto */
      #sub {
        opacity: 0.6;
        font-size: 0.85em;
        color: @foreground;
        margin-top: 2px;
      }

      /* Modo activación */
      .activation #activationlabel {
        color: @accent;
      }

      .activation #text,
      .activation #icon,
      .activation #search {
        opacity: 0.5;
      }

      /* Items de AI */
      .aiItem {
        padding: 12px;
        border-radius: 6px;
        color: @foreground;
        background: @background;
        margin: 4px 0;
      }

      .aiItem.user {
        padding-left: 0;
        padding-right: 0;
        background: transparent;
      }

      .aiItem.assistant {
        background: @background_light;
        border-left: 3px solid @accent;
        padding-left: 12px;
      }

      /* Scrollbar */
      scrollbar {
        background: transparent;
      }

      slider {
        background: alpha(@foreground, 0.3);
        border-radius: 4px;
        min-width: 6px;
      }

      slider:hover {
        background: alpha(@foreground, 0.5);
      }
    '';
}
