{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.homeModules.niri
    ./config/binds.nix
    ./config/env.nix
    ./config/settings.nix
    ./config/startup.nix
    ./config/windowrules.nix
  ];
  nixpkgs.overlays = [inputs.niri.overlays.niri];
  home.packages = with pkgs; [
    xwayland-satellite-unstable
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
    #soteria
    # Image Viewer
    imv
    # XWayland/Wayland
    #glfw
    wlr-randr
    #wlprop
    #wlroots
    wayland-utils
    #xwayland
    # xwayland-satellite
    xcb-util-cursor
    xorg.libxcb
    xorg.xprop
    xorg.xkbcomp
  ];
}
