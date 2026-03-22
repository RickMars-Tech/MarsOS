{
  pkgs,
  lib,
  ...
}: let
  sddmTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = "purple_leaves";
    themeConfig = {
      HourFormat = "hh:mm AP";
    };
  };
in {
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = lib.mkForce pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";

    settings = {
      General = {
        InputMethod = "qtvirtualkeyboard";
      };
    };

    extraPackages = with pkgs; [
      kdePackages.qtsvg
      kdePackages.qtmultimedia
      kdePackages.qtvirtualkeyboard
      kdePackages.qtdeclarative
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav
    ];
  };

  systemd.services.display-manager.environment = {
    QT_IM_MODULE = "qtvirtualkeyboard";
    QT_VIRTUALKEYBOARD_DESKTOP_DISABLE = "1";
  };

  environment.systemPackages = [
    sddmTheme
  ];
}
