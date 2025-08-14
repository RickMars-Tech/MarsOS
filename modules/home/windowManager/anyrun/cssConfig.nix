{config, ...}: let
  color = config.lib.stylix.colors;
  font = config.stylix.fonts.sansSerif.name;
in {
  # custom css for anyrun, based on catppuccin-mocha
  programs.anyrun.extraCss = ''
    @define-color bg-col  ${color.base01};
    @define-color bg-col-light ${color.base04};
    @define-color border-col ${color.base02};
    @define-color selected-col ${color.base0C};
    @define-color fg-col ${color.base03};
    @define-color fg-col2 ${color.base0F};

    * {
      transition: 200ms ease;
      font-family: "${font}";
      font-size: 1.3rem;
    }

    #window {
      background: transparent;
    }

    #plugin,
    #main {
      border: 3px solid @border-col;
      color: @fg-col;
      background-color: @bg-col;
    }
    /* anyrun's input window - Text */
    #entry {
      color: @fg-col;
      background-color: @bg-col;
    }

    /* anyrun's output matches entries - Base */
    #match {
      color: @fg-col;
      background: @bg-col;
    }

    /* anyrun's selected entry - Red */
    #match:selected {
      color: @fg-col2;
      background: @selected-col;
    }

    #match {
      padding: 3px;
      border-radius: 16px;
    }

    #entry, #plugin:hover {
      border-radius: 16px;
    }

    box#main {
      background: rgba(30, 30, 46, 0.7);
      border: 1px solid @border-col;
      border-radius: 15px;
      padding: 5px;
    }
  '';
}
