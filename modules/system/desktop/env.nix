{
  pkgs,
  lib,
  ...
}: let
  extest = "${pkgs.extest}/lib/libextest.so";
  firefox = "${pkgs.firefox}/bin/firefox";
  terminal = "${pkgs.wezterm}/bin/wezterm";
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
    };
  };
}
