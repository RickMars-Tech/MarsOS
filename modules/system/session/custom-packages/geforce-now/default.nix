# Why prefer Gfn-Electron Appimage over Flatpak or Nix???
# It's easy, the latest versions of Gfn-Electron Flatpak and "Native" Nix,
# have a limited mouse movement bug on Wayland,
# the Appimage version doesn't so i decided to use the AppImage version but in the Nix way :)
{
  appimageTools,
  electron,
  fetchurl,
  lib,
  makeWrapper,
  ...
}: let
  pname = "geforcenow-electron";
  version = "2.1.3";
  src = fetchurl {
    url = "https://github.com/hmlendea/gfn-electron/releases/download/v${version}/geforcenow-electron_${version}_linux.AppImage";
    sha256 = "sha256-HO6ftxCNLgduJkv5KnmLkfQfm4/o+a9y0SxpdH6IqPI=";
  };
  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;
    nativeBuildInputs = [makeWrapper];
    extraInstallCommands = ''
      install -Dm644 ${appimageContents}/com.github.hmlendea.geforcenow-electron.desktop -t $out/share/applications
      install -Dm644 ${appimageContents}/geforcenow-electron.png \
       $out/share/icons/hicolor/512x512/apps/geforcenow-electron.png
      substituteInPlace $out/share/applications/com.github.hmlendea.geforcenow-electron.desktop \
        --replace 'Exec=/opt/geforcenow-electron/geforcenow-electron' 'Exec=${pname}' \
        --replace 'Icon=nvidia' 'Icon=geforcenow-electron'
      wrapProgram $out/bin/${pname} \
        --add-flags "--no-sandbox --disable-gpu-sandbox"
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
