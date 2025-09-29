{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  uwsm = osConfig.programs.uwsm;
  nvidiaPro = osConfig.mars.graphics.nvidiaPro;
in {
  programs.niri.settings = {
    environment = {
      NIRI_DISABLE_SYSTEM_MANAGER_NOTIFY = mkIf uwsm.enable "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      #= Wayland Backend
      GDK_BACKEND = "wayland";
      CLUTTER_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_WEBRENDER = "1";
      NIXOS_OZONE_WL = "1";
      OZONE_PLATFORM = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland,x11";

      #= Nvidia
      WLR_NO_HARDWARE_CURSORS = mkIf nvidiaPro.wayland-fixes "1";

      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "niri";
    };
  };
}
