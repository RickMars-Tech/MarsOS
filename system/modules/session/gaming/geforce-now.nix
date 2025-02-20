# Why prefer Gfn-Electron appimage over Flatpak or Nix???
# It's easy, the latest versions of Gfn-Electron Flatpak and "Native" Nix,
# have a limited mouse movement bug on Wayland,
# the Appimage version doesn't so i decided to use the AppImage version but in the Nix way :)
{
  appimageTools,
  electron,
  fetchurl,
  lib,
  ...
}: let
  version = "2.1.3";
  pname = "geforcenow-electron";
  src = fetchurl {
    url = "https://github.com/hmlendea/gfn-electron/releases/download/v${version}/geforcenow-electron_${version}_linux.AppImage";
    hash = "sha256-HO6ftxCNLgduJkv5KnmLkfQfm4/o+a9y0SxpdH6IqPI=";
  };
  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 rec {
    inherit pname version src;
    unshareIpc = false;

    extraInstallCommands = ''
      mv $out/bin/${pname} $out/bin/${pname}-desktop
      install -m 444 -D ${appimageContents}/geforcenow-electron.desktop $out/share/applications/geforcenow-electron.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/geforcenow-electron.png \
        $out/share/icons/hicolor/0x0/apps/geforcenow-electron.png
      substituteInPlace $out/share/applications/${pname}.desktop --replace-fail 'Exec=AppRun' 'Exec=${pname}-desktop'
    '';

    meta = {
      description = "Linux Desktop client for Nvidia's GeForce NOW game streaming service";
      homepage = "https://github.com/hmlendea/gfn-electron";
      license = lib.licenses.gpl3Only;
      platforms = lib.intersectLists lib.platforms.linux electron.meta.platforms;
      maintainers = with lib.maintainers; [RickMars-Tech];
      mainProgram = "geforcenow-electron";
    };
  }
