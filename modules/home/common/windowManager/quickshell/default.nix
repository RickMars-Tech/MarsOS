{
  pkgs,
  inputs,
  ...
}: let
  quickshellDir = ./config;
in {
  programs.quickshell = {
    enable = true;
    package = inputs.quickshell.packages.${pkgs.system}.default;
    systemd.enable = true;
  };

  #|==< Config Files >==|#
  home.file.".config/quickshell" = {
    enable = true;
    recursive = true;
    source = quickshellDir;
  };

  #|==< Extra Packages >==|#
  home.packages = with pkgs; [
    qt6.qt5compat
    qt6.qtbase
    qt6.qtquick3d
    qt6.qtwayland
    qt6.qtdeclarative
    qt6.qtsvg

    # alternate options
    # libsForQt5.qt5compat
    kdePackages.qt5compat
    kdePackages.qtdeclarative
    libsForQt5.qt5.qtgraphicaleffects

    material-symbols
    google-fonts
    brightnessctl
    cava
  ];
}
