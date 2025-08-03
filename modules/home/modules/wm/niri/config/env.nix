_: {
  programs.niri.settings = {
    environment = {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      NIRI_DISABLE_SYSTEM_MANAGER_NOTIFY = "1";
      #NIXOS_OZONE_WL = "1";
      #= Backend
      GDK_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      DISPLAY = ":0";
    };
  };
}
