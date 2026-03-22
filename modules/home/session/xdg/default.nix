{
  # lib,
  pkgs,
  ...
}: let
  browser = ["firefox.desktop"];
  imageViewer = ["swayimg.desktop"];
  videoPlayer = ["mpv.desktop"];
  audioPlayer = ["io.bassi.Amberol.desktop"];
  textEditor = ["hx.desktop"];

  xdgAssociations = type: program: list:
    builtins.listToAttrs (map (e: {
        name = "${type}/${e}";
        value = program;
      })
      list);

  image = xdgAssociations "image" imageViewer ["png" "jpg" "jpeg" "gif" "webp" "bmp" "tiff" "tif" "ico" "svg" "avif" "heic" "heif"];
  video = xdgAssociations "video" videoPlayer ["mp4" "avi" "mkv" "mov" "wmv" "flv" "webm" "m4v" "3gp" "ogv" "ts" "mts" "m2ts"];
  audio = xdgAssociations "audio" audioPlayer ["mp3" "flac" "wav" "aac" "ogg" "oga" "opus" "m4a" "wma" "ape" "alac" "aiff"];
  text = xdgAssociations "text" textEditor [
    "markdown"
    "x-shellscript"
    "x-python"
    "x-go"
    "css"
    "javascript"
    "x-c"
    "x-c++"
    "x-java"
    "x-rust"
    "x-yaml"
    "x-toml"
    "x-dockerfile"
    "x-xml"
    "x-php"
    "x-nix"
  ];

  browserTypes =
    (xdgAssociations "application" browser ["json" "x-extension-htm" "x-extension-html" "x-extension-shtml" "x-extension-xht" "x-extension-xhtml"])
    // (xdgAssociations "x-scheme-handler" browser ["about" "ftp" "http" "https" "unknown"]);

  associations =
    {
      "application/pdf" = ["org.gnome.Papers.desktop"];
      "application/zip" = ["org.gnome.FileRoller.desktop"];
      "application/x-7z-compressed" = ["org.gnome.FileRoller.desktop"];
      "application/x-rar-compressed" = ["org.gnome.FileRoller.desktop"];
      "application/x-tar" = ["org.gnome.FileRoller.desktop"];
      "application/gzip" = ["org.gnome.FileRoller.desktop"];
      "text/html" = browser;
    }
    // image // video // audio // text // browserTypes;
in {
  imports = [./xdg-compat.nix];
  xdg = {
    portal = {
      enable = true;
      config = {
        common = {
          default = ["gtk"]; # simplifica a uno solo
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          # default = ["gnome" "gtk"];
          "org.freedesktop.impl.portal.ScreenCast" = "gnome";
          "org.freedesktop.impl.portal.Screenshot" = "gnome";
          "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
          "org.freedesktop.impl.portal.OpenURI" = "gtk";
          "org.freedesktop.impl.portal.OpenFile" = "gtk";
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };
    mime.addedAssociations = associations;
  };

  environment.sessionVariables = rec {
    XDG_BACKUP_DIR = "$HOME/Backup";
    XDG_GAMES_DIR = "$HOME/Games";
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/Screenshots";

    # NIX_XDG_DESKTOP_PORTAL_DIR = lib.mkForce null;
    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };
}
