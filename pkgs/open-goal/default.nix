{
  appimageTools,
  makeWrapper,
  fetchurl,
  lib,
}:
let
  pname = "OpenGOAL-Launcher";
  version = "2.8.6";

  src = fetchurl {
    url = "https://github.com/open-goal/launcher/releases/download/v${version}/OpenGOAL-Launcher_${version}_amd64.AppImage";
    sha256 = "sha256-2mC3XvRdXQFuFnw9gnD+XLBg3TKjYRaS2FOQdRDgwBY=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/${pname}

    install -Dm644 ${appimageContents}/usr/share/applications/${pname}.desktop -t $out/share/applications

    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A launcher for the OpenGOAL Project to simplify usage and installation";
    homepage = "https://github.com/open-goal/launcher";
    license = licenses.isc;
    maintainers = [ "RickMars" ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "open-goal-launcher";
  };
}
