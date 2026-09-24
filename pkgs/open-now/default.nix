{
  appimageTools,
  makeWrapper,
  fetchurl,
  lib,
}:
let
  pname = "OpenNow";
  version = "1.0.1";

  src = fetchurl {
    url = "https://github.com/OpenCloudGaming/${pname}/releases/download/v${version}/${pname}-Qt-${version}-Linux-x64.AppImage";
    sha256 = "sha256-tL0GGrETsmpCxiaqYOh4tEweTcQ8z+4T7EY6HOl3ya0=";
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

    install -Dm644 ${appimageContents}/usr/share/applications/io.github.opencloudgaming.OpenNOW.desktop -t $out/share/applications

    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A launcher for the OpenGOAL Project to simplify usage and installation";
    homepage = "https://github.com/OpenCloudGaming/OpenNow";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "Open-Now";
  };
}
