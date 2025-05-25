{pkgs, ...}: {
  imports = [
    #./cosmic.nix
    ./packages.nix
    #./waydroid.nix
  ];
  services.xserver.enable = false;
  programs.xwayland.enable = false;

  #= Lock Session
  programs.hyprlock.enable = true;

  #= Session idle
  services.hypridle.enable = true;

  #= XDG
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config.common.default = "gtk";
      wlr.enable = true;
      lxqt.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
        kdePackages.xdg-desktop-portal-kde
        #libsForQt5.xdg-desktop-portal-kde
        #lxqt.xdg-desktop-portal-lxqt
      ];
    };
    sounds.enable = true;
    autostart.enable = true;
    menus.enable = true;
    mime = {
      enable = true;
      defaultApplications = {
        "application/x-extension-htm" = "librewolf.desktop";
        "application/x-extension-html" = "librewolf.desktop";
        "application/x-extension-shtml" = "librewolf.desktop";
        "application/xhtml+xml" = "librewolf.desktop";
        "application/x-extension-xhtml" = "librewolf.desktop";
        "application/x-extension-xht" = "librewolf.desktop";
        "application/pdf" = "zathura.desktop";
        "text/markdown" = "hx.desktop";
        "text/plain" = "hx.desktop";
        "text/x-shellscript" = "hx.desktop";
        "text/x-python" = "hx.desktop";
        "text/x-go" = "hx.desktop";
        "text/css" = "hx.desktop";
        "text/javascript" = "hx.desktop";
        "text/x-c" = "hx.desktop";
        "text/x-c++" = "hx.desktop";
        "text/x-java" = "hx.desktop";
        "text/x-rust" = "hx.desktop";
        "text/x-yaml" = "hx.desktop";
        "text/x-toml" = "hx.desktop";
        "text/x-dockerfile" = "hx.desktop";
        "text/x-xml" = "hx.desktop";
        "text/x-php" = "hx.desktop";
        "image/png" = "imv-dir.desktop";
        "image/jpg" = "imv-dir.desktop";
        "image/jpeg" = "imv-dir.desktop";
        "image/gif" = "imv-dir.desktop";
        "image/svg" = "imv-dir.desktop";
        "image/tiff" = "imv-dir.desktop";
        "video/avi" = "mpv.desktop";
        "video/mp4" = "mpv.desktop";
        "video/mkv" = "mpv.desktop";
      };
    };
  };
}
