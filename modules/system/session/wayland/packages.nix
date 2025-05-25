{
  pkgs,
  #inputs,
  ...
}: {
  #nixpkgs.overlays = [inputs.hyprpanel.overlay];

  environment.systemPackages = with pkgs; [
    # Wallpaper Setter
    #waytrogen
    # Status Bar
    waybar
    # App-Launcher
    fuzzel
    #rofi-wayland-unwrapped
    # Screen-Locker
    wlogout
    # Brightnes Manager
    brightnessctl
    # Clipboard-specific
    wl-clipboard-rs
    cliphist
    #clapboard
    # Screenshot
    grimblast # Taking
    slurp # Selcting
    swappy # Editing
    #= Polkit
    polkit
    soteria
    # Image Viewer
    imv
    # XWayland/Wayland
    #glfw
    wlr-randr
    #wlprop
    #wlroots
    wayland-utils
    xwayland
    #xwayland-run
    xwayland-satellite
    xcb-util-cursor
    xorg.libxcb
    xorg.xprop
    xorg.xkbcomp
  ];
}
