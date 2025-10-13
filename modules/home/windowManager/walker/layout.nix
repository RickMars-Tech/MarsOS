_: {
  services.walker.theme = {
    name = "mars";
    layout = {
      close_when_open = true;
      hotreload_theme = true;
      force_keyboard_focus = true;
      timeout = 60;

      keys.ai.run_last_response = ["ctrl e"];

      list = {
        max_entries = 200;
        cycle = true;
      };

      search.placeholder = " Search...";

      builtins = {
        applications = {
          launch_prefix = "uwsm app -- ";
          placeholder = " Search...";
          prioritize_new = false;
          context_aware = false;
          show_sub_when_single = false;
          history = false;
          icon = "";
          hidden = true;
          actions = {
            enabled = false;
            hide_category = true;
          };
        };
        bookmarks.hidden = true;
        windows = {
          switcher_only = true;
          hidden = true;
        };
        clipboard.hidden = true;
        commands.hidden = true;
        symbols = {
          after_copy = "";
          hidden = true;
        };
        finder = {
          use_fd = true;
          cmd_alt = "xdg-open $(dirname ~/%RESULT%)";
          icon = "file";
          name = "Finder";
          preview_images = true;
          hidden = false;
          prefix = ".";
        };
        runner = {
          shell_config = "";
          switcher_only = true;
          hidden = true;
        };
        websearch = {
          switcher_only = true;
          hidden = true;
        };
      };
    };
  };
}
