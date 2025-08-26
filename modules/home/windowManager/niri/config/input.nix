_: {
  programs.niri.settings.input = {
    #= Keyboard
    keyboard.xkb = {
      layout = "latam";
      variant = "";
      # options = "compose:ralt";
    };
    #= Touchpad
    touchpad = {
      accel-profile = "flat";
      click-method = "button-areas";
      dwt = false;
      dwtp = false;
      natural-scroll = false;
      scroll-method = "two-finger";
      tap = true;
      tap-button-map = "left-right-middle";
    };
    #= Trackpoint
    trackpoint = {
      enable = true;
      accel-profile = "flat";
    };
    #= Mouse
    mouse = {
      enable = true;
      accel-profile = "flat";
      scroll-factor = 1.0;
    };
    focus-follows-mouse.enable = false;
    warp-mouse-to-focus.enable = true;
    workspace-auto-back-and-forth = true;
  };
}
