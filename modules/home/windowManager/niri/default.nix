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
    ./config/input.nix
    ./config/outputs.nix
    ./config/settings.nix
    ./config/startup.nix
    ./config/windowrules.nix
  ];
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  #= Setup Niri
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings.xwayland-satellite = {
      enable = true;
      path = getExe pkgs.xwayland-satellite;
    };
  };

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
  ];

  #= Used Packages
  home.packages = with pkgs; [
    gnome-keyring
    # xwayland-satellite
    # Clipboard-specific
    wl-clipboard-rs
    cliphist
    # Image Viewer
    imv
    # XWayland/Wayland
    wlr-randr
    wayland-utils
    xcb-util-cursor
    xorg.libxcb
    xorg.xprop
    xorg.xkbcomp
  ];
}
