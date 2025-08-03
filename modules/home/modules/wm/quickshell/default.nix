{
  pkgs,
  inputs,
  ...
}: let
  quickshellDir = ./qml;
in {
  imports = [
    ./theme.nix
  ];

  #|==< Packages >==|#
  home.packages = with pkgs; [
    #(inputs.quickshell.packages.${pkgs.system}.default)
    (inputs.quickshell.packages.${pkgs.system}.default.override {
      withJemalloc = true;
      withQtSvg = true;
      withWayland = true;
      withX11 = false;
      withPipewire = true;
      withPam = true;
      withHyprland = false;
      withI3 = false;
    })
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

  qt.enable = true;

  #|==< Config Files >==|#
  home.file.".config/quickshell" = {
    enable = true;
    recursive = true;
    source = quickshellDir;
  };
}
