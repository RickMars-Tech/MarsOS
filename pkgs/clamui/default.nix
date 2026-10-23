{
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  gobject-introspection,
  wrapGAppsHook4,
  gtk4,
  libadwaita,
  glib,
  cairo,
  pkg-config,
  lib,
  copyDesktopItems,
  makeDesktopItem,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "clamui";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "linx-systems";
    repo = "clamui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LxL9eAzk/uaJbi94wRWe4k78qOaJ6cH24dVBEDdCJSc=";
  };

  pyproject = true;

  # desajuste de versiones, necesita v2.8 o mayor y nixpkgs al momento solo tiene v2.7
  pythonRelaxDeps = [ "urllib3" ];

  build-system = with python3Packages; [
    hatchling
  ];

  # Completa las dependencias Python según pyproject.toml.
  dependencies = with python3Packages; [
    certifi
    matplotlib
    keyring
    psutil
    pillow
    pygobject3
    requests
    urllib3
  ];

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook4
    copyDesktopItems
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
    cairo
  ];

  # El wheel no incluye .desktop ni iconos (se generan en el build de meson,
  # que aquí no se ejecuta). Se traen del repo del tag y se instalan a mano.
  desktopItem = makeDesktopItem {
    name = "io.github.linx_systems.ClamUI";
    desktopName = "ClamUI";
    genericName = "Antivirus Scanner";
    comment = "A graphical interface for ClamAV antivirus";
    exec = "clamui %U";
    icon = "io.github.linx_systems.ClamUI";
    terminal = false;
    categories = [
      "GTK"
      "Utility"
      "Security"
    ];
    keywords = [
      "antivirus"
      "virus"
      "scanner"
      "clamav"
      "security"
      "malware"
      "virustotal"
    ];
    startupNotify = true;
    startupWMClass = "io.github.linx_systems.ClamUI";
  };

  iconSvg = fetchurl {
    url = "https://raw.githubusercontent.com/linx-systems/clamui/v${finalAttrs.version}/icons/io.github.linx_systems.ClamUI.svg";
    hash = "sha256-cOpcaWzcPium6hSRSjLHL2veI00e0bjJ4Dlv9d4Ch5w=";
  };

  iconPng = fetchurl {
    url = "https://raw.githubusercontent.com/linx-systems/clamui/v${finalAttrs.version}/icons/io.github.linx_systems.ClamUI.png";
    hash = "sha256-Zn7iqinsLSONNTEjKXlnIDhyQS17Ha2uF5YSrpN6Ckg=";
  };

  metainfo = fetchurl {
    url = "https://raw.githubusercontent.com/linx-systems/clamui/v${finalAttrs.version}/data/io.github.linx_systems.ClamUI.metainfo.xml";
    hash = "sha256-hCU33S787lEiY1cXPOCHk4uNJ8Eczscw0ccr/CJ23d4=";
  };

  desktopItems = [ finalAttrs.desktopItem ];

  postInstall = ''
    # Iconos (svg + png) en el tema hicolor
    install -Dm644 ${finalAttrs.iconSvg} \
      $out/share/icons/hicolor/scalable/apps/io.github.linx_systems.ClamUI.svg
    install -Dm644 ${finalAttrs.iconPng} \
      $out/share/icons/hicolor/256x256/apps/io.github.linx_systems.ClamUI.png

    # Metainfo de AppStream
    install -Dm644 ${finalAttrs.metainfo} \
      $out/share/metainfo/io.github.linx_systems.ClamUI.metainfo.xml
  '';

  meta = with lib; {
    description = "GTK4/libadwaita graphical interface for the ClamAV antivirus";
    homepage = "https://github.com/linx-systems/clamui";
    license = licenses.mit;
    maintainers = [ "RickMars-Tech" ];
    platforms = platforms.linux;
    mainProgram = "clamui";
  };
})
