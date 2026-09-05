{
  flake.wrapperModules.niriInput.config.settings.input = {
    keyboard.xkb = {
      layout = "latam";
      variant = "";
      options = "";
    };
    touchpad = {
      accel-profile = "flat";
      click-method = "button-areas";
      natural-scroll = _: { };
      scroll-method = "two-finger";
      tap = _: { };
      tap-button-map = "left-right-middle";
    };
    trackpoint.accel-profile = "flat";
    mouse = {
      accel-profile = "flat";
      scroll-factor = 1.0;
    };
    warp-mouse-to-focus = _: { };
    workspace-auto-back-and-forth = _: { };
  };
}
