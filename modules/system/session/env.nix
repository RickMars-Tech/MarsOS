{
  pkgs,
  lib,
  ...
}: let
  extest = "${pkgs.extest}/lib/libextest.so";
  soteria = lib.getExe pkgs.soteria;
in {
  environment = {
    sessionVariables = {
      #|==< Default's >==|#
      EDITOR = "hx";
      BROWSER = "librewolf";
      TERMINAL = "wezterm";
      #|==< Polkit >==|#
      POLKIT_BIN = "${soteria}";
      #|==< JAVA >==|#
      _JAVA_AWT_WM_NONREPARENTING = "1";
      #|==< Intel Graphics >==|#
      LIBVA_DRIVER_NAME = "i965";
      #|==< Load Shared Objects Immediately >==|#
      LD_BIND_NOW = "1";
      LD_PRELOAD = "${extest}";
      #|==< Steam >==|#
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
      #|==< Wayland >==|#
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      OZONE_PLATFORM = "wayland";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
    };
  };
}
