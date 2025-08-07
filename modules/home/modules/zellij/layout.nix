_: {
  programs.zellij.layouts = {
    dev = {
      layout = {
        _children = [
          {
            default_tab_template = {
              _children = [
                {"children" = {};}
                {
                  pane = {
                    size = 1;
                    borderless = true;
                    plugin = {
                      location = "zellij:tab-bar";
                    };
                  };
                }
                # {
                #   pane = {
                #     size = 2;
                #     borderless = true;
                #     plugin = {
                #       location = "zellij:status-bar";
                #     };
                #   };
                # }
              ];
            };
          }
          #==< Tabs Config >==#
          #= Shell
          {
            tab._props = {
              name = "Shell";
              focus = true;
            };
          }
          #= FileManager
          {
            tab = {
              _props.name = "Files";
              _children = [
                {
                  pane = {
                    command = "yazi";
                  };
                }
              ];
            };
          }
        ];
      };
    };
  };
}
