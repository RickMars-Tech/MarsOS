_: {
  programs.zellij.settings = {
    default_layout = "dev";

    # Mouse configuration
    advanced_mouse_actions = true;
    mouse_mode = true;
    scroll_buffer_size = 12000;

    # Copy configuration
    copy_clipboard = "system";
    copy_command = "wl-copy";
    copy_on_select = true;

    # Pane Frames
    pane_frames = false;
    ui = {
      # Dont have effect if papane_frames its disabled
      pane_frames = {
        rounded_corners = true;
        hide_session_name = true;
      };
    };
    auto_layout = false;

    # Session configuration
    session_serialization = false;
    disable_session_metadata = true;

    web_server = false;
  };
}
