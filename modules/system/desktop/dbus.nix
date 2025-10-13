{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkForce;
in {
  services.dbus = {
    enable = true;
    implementation = mkForce "broker";
    packages = with pkgs; [
      greetd
      tuigreet
      brightnessctl
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
}
