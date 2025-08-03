{config, ...}: let
  stlx = config.stylix.base16Scheme;
  homeDir = config.home.homeDirectory;
  quickshellTheme = "${homeDir}/.config/quickshell/Settings/Theme.json";
in {
  xdg.configFile.quickTheme = {
    enable = true;
    target = quickshellTheme;
    text = ''
      {
      "backgroundPrimary": "${stlx.base00}",
      "backgroundSecondary": "${stlx.base01}",
      "backgroundTertiary": "${stlx.base02}",

      "surface": "${stlx.base03}",
      "surfaceVariant": "${stlx.base03}",

      "textPrimary": "${stlx.base05}",
      "textSecondary": "${stlx.base06}",
      "textDisabled": "${stlx.base07}",

      "accentPrimary": "${stlx.base05}",
      "accentSecondary": "${stlx.base06}",
      "accentTertiary": "${stlx.base07}",

      "error": "${stlx.base08}",
      "warning": "${stlx.base0F}",

      "highlight": "${stlx.base0B}",
      "rippleEffect": "${stlx.base0A}",

      "onAccent": "${stlx.base01}",
      "outline": "${stlx.base03}",

      "shadow": "${stlx.base02}",
      "overlay": "${stlx.base02}"
      }
    '';
  };
}
