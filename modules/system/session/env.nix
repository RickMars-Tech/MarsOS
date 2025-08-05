{
  pkgs,
  lib,
  ...
}: let
  extest = "${pkgs.extest}/lib/libextest.so";
  firefox = "${pkgs.firefox}/bin/firefox";
  terminal = "${pkgs.ghostty}/bin/ghostty";
  soteria = lib.getExe pkgs.soteria;
in {
  environment = {
    sessionVariables = {
      #|==< Default's >==|#
      EDITOR = "hx";
      BROWSER = "${firefox}";
      TERMINAL = "${terminal}";

      #|==< Polkit >==|#
      POLKIT_BIN = "${soteria}";

      #|==< JAVA >==|#
      _JAVA_AWT_WM_NONREPARENTING = "1";

      #|==< Load Shared Objects Immediately >==|#
      LD_BIND_NOW = "1";
      LD_PRELOAD = "${extest}";

      #|==< Steam >==|#
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";

      #|==< QT/QuickShell >==|#
      QML_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml";
      QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml";

      #|==< Wayland >==|#
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      OZONE_PLATFORM = "wayland";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
    };
  };
}
