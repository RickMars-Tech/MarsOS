{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf getExe;
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

  xdg.portal = {
    extraPortals = with pkgs;
      mkIf config.programs.niri.enable [
        xdg-desktop-portal-gnome
      ];
  };

  #= Used Packages
  home.packages = with pkgs; [
    # Wayland Output Mirror Client
    wl-mirror
    # Prevents swayidle from sleeping while any application is outputting or receiving audio.
    sway-audio-idle-inhibit
    gnome-keyring
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
