{
  programs.niri.settings.input = {
    #= Keyboard
    keyboard.xkb = {
      layout = "latam";
      variant = "";
      options = "";
    };
    #= Touchpad
    touchpad = {
      accel-profile = "flat";
      click-method = "button-areas";
      natural-scroll = {};
      scroll-method = "two-finger";
      tap = {};
      tap-button-map = "left-right-middle";
    };
    #= Trackpoint
    trackpoint = {
      accel-profile = "flat";
    };
    #= Mouse
    mouse = {
      accel-profile = "flat";
      scroll-factor = 1.0;
    };
    warp-mouse-to-focus = {};
    workspace-auto-back-and-forth = {};
  };
}
