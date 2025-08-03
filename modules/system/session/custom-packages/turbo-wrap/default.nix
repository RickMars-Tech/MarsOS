# Another example from how to "Install" an Appimage on NixOS
{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}: let
  version = "1.14.4";
  pname = "turbowarp";
  src = fetchurl {
    url = "https://github.com/TurboWarp/desktop/releases/download/v${version}/TurboWarp-linux-x86_64-${version}.AppImage";
    sha256 = "sha256-Ck04g/9Ehy0PNulmSJBBWnFD7LvQM54e8RyltfijVHA="; #lib.fakeSha256;
  };
  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;
    nativeBuildInputs = [makeWrapper];
    extraInstallCommands = ''
      install -Dm644 ${appimageContents}/linux-files/org.turbowarp.TurboWarp.desktop -t $out/share/applications
      install -Dm644 ${appimageContents}/turbowarp-desktop.png \
        $out/share/icons/hicolor/512x512/apps/turbowarp-desktop.png
      substituteInPlace $out/share/applications/org.turbowarp.TurboWarp.desktop \
        --replace 'Exec=/opt/TurboWarp/turbowarp-desktop' 'Exec=${pname}' \
        --replace 'Icon=turbowarp-desktop' 'Icon=turbowarp-desktop'
    '';

    meta = {
      description = "A better offline editor for Scratch 3";
      homepage = "https://github.com/TurboWarp/desktop";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [RickMars-Tech];
      mainProgram = "turbo-wrap";
    };
  }
