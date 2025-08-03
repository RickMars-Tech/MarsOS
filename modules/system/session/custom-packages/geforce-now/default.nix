# Why prefer Gfn-Electron Appimage over Flatpak or Nix???
# It's easy, im very stupid to know how to build an Electron App with yarn or npm
# Enjoy :3
{
  appimageTools,
  electron,
  fetchurl,
  lib,
  makeWrapper,
  ...
}: let
  pname = "geforce-infinity";
  version = "1.1.3";
  src = fetchurl {
    url = "https://github.com/AstralVixen/GeForce-Infinity/releases/download/${version}/GeForceInfinity-linux-${version}-x86_64.AppImage";
    sha256 = "sha256-C2bHMOWfYVJ1vpQlbq0KWqQRqXkT19+W+q5No9G4l6Q="; #lib.fakeSha256;
  };
  appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;
    nativeBuildInputs = [makeWrapper];
    extraInstallCommands = ''
      install -Dm644 ${appimageContents}/geforce-infinity.desktop -t $out/share/applications
      install -Dm644 ${appimageContents}/geforce-infinity.png \
       $out/share/icons/hicolor/500x500/apps/geforce-infinity.png
      substituteInPlace $out/share/applications/geforce-infinity.desktop \
        --replace 'Exec=/opt/geforce-infinity/geforce-infinity' 'Exec=${pname}' \
        --replace 'Icon=nvidia' 'Icon=geforce-infinity'
      wrapProgram $out/bin/${pname} \
        --add-flags "--no-sandbox --disable-gpu-sandbox"
    '';

    meta = {
      description = "A Next-Gen Application designed to Enhance The GeForce NOW Experience";
      homepage = "https://github.com/AstralVixen/GeForce-Infinity";
      license = with lib.licenses; [mit];
      platforms = lib.intersectLists lib.platforms.linux electron.meta.platforms;
      maintainers = ["RickMars-Tech"];
      mainProgram = "geforce-infinity";
    };
  }
