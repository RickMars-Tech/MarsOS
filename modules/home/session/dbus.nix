{pkgs, ...}: {
  services.dbus = {
    enable = true;
    implementation = "broker";
    packages = with pkgs; [
      gamemode
      nautilus
      xdg-desktop-portal
      xdg-desktop-portal-gnome
    ];
  };
}
