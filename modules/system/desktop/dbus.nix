{pkgs, ...}: {
  services.dbus = {
    enable = true;
    implementation = "dbus"; # lib.mkForce "broker";
    packages = with pkgs; [
      appimage-run
      dunst
      greetd
      tuigreet
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };
}
