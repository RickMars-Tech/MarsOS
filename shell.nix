{pkgs ? import <nixpkgs> {}}:
with pkgs;
  mkShell rec {
    nativeBuildInputs = [
      pkg-config
    ];
    buildInputs = [
      udev
      alsa-lib
      xorg.libX11
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr # To use the x11 feature
      libxkbcommon
      wayland # To use the wayland feature
      #staruml # To use the staruml feature
    ];
    LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;

    allowUnfree = true;
    allowBrocken = true;
  }
