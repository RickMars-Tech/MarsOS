{
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  imports = [
    inputs.niri.homeModules.niri
    ./config/binds.nix
    ./config/env.nix
    ./config/outputs.nix
    ./config/settings.nix
    ./config/startup.nix
    ./config/windowrules.nix
  ];
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  #= SetUp Niri(Unstable)
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    #= Xwayland-Satellite
    settings.xwayland-satellite = {
      enable = true;
      path = "${getExe pkgs.xwayland-satellite-unstable}";
    };
  };
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  #= Used Packages
  home.packages = with pkgs; [
    gnome-keyring
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
