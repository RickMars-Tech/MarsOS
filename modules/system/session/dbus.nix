{
  pkgs,
  lib,
  ...
}: {
  services.dbus = {
    enable = true;
    implementation = lib.mkForce "broker";
    packages = with pkgs; [
      appimage-run
      dunst
      greetd.greetd
      greetd.tuigreet
      # greetd.regreet
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      libsForQt5.xdg-desktop-portal-kde
      lxqt.xdg-desktop-portal-lxqt
    ];
  };
}
