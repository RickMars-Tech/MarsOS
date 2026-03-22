{
  layout._children = [
    {
      default_tab_template._children = [
        {"children" = {};}
        {
          pane = {
            size = 1;
            borderless = true;
            plugin.location = "zellij:tab-bar";
          };
        }
      ];
    }
    {
      tab._props = {
        name = "Shell";
        focus = true;
      };
    }
    {
      tab = {
        _props.name = "Yazi";
        _children = [
          {
            pane = {
              command = "yazi";
              size = "100%";
            };
          }
        ];
      };
    }
    {
      tab._props = {
        name = "Dev";
      };
    }
  ];
}
