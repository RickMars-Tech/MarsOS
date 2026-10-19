{
  appimageTools,
  makeWrapper,
  fetchurl,
  lib,
}:
let
  pname = "Bloodborne-bbport";
  version = "0.4";

  src = fetchurl {
    url = "https://github.com/deadinside28/bloodborne_pc/releases/download/${version}/${pname}-x86_64.AppImage";
    sha256 = lib.fakeHash;
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
    description = "bbport — a native Linux port of Bloodborne";
    homepage = "https://github.com/deadinside28/bloodborne_pc";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
    mainProgram = "Bloodborne PC";
  };
}
