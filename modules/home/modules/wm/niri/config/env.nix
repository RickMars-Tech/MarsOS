{username, ...}: {
  programs.niri.settings = {
    environment = {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      NIRI_DISABLE_SYSTEM_MANAGER_NOTIFY = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      #= Backend
      GDK_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";

      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "niri";

      XDG_DESKTOP_PORTAL_FORCE_GNOME = "1";

      DISPLAY = ":0";

      XDG_DATA_DIRS = "/home/${username}/.nix-profile/share:/nix/var/nix/profiles/default/share:/run/current-system/sw/share";
      XDG_CONFIG_DIRS = "/etc/xdg";
    };
  };
}
