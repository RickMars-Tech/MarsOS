{
  lib,
  stdenvNoCC,
  fetchzip,
  writeScript,
}:

# Proton EM (Etaash-mathamsetty) "HDR" build, empaquetado al estilo de
# proton-cachyos: extraemos el tarball en $out y dejamos $steamcompattool, que
# es el output que Steam espera en programs.steam.extraCompatPackages.
#
# Upstream: https://github.com/Etaash-mathamsetty/Proton
# Para actualizar: cambia `version`, baja el asset, calcula el sha256 con
# `nix-prefetch-url <url>` y pégalo en `hash`.
let
  steamDisplayName = "Proton EM";
  version = "10.0-37";
in
stdenvNoCC.mkDerivation {
  pname = "proton-em";
  inherit version;

  outputs = [
    "out"
    "steamcompattool"
  ];

  # Igual que proton-ge-bin: no se instala en el entorno, se usa desde la
  # opción de Steam.
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  src = fetchzip {
    url = "https://github.com/Etaash-mathamsetty/Proton/releases/download/EM-${version}-HDR/proton-EM-${version}-HDR.tar.xz";
    hash = "sha256-yap/7G6TeJ9vMtc5H/iWu8w3sM8mI6762G+K2JzSlgk=";
  };

  installPhase = ''
    runHook preInstall

    echo "${steamDisplayName} should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    mkdir $steamcompattool
    ln -s $src/* $steamcompattool

    # El vdf del tarball apunta al nombre upstream; se copia (no symlink) para
    # poder parchearlo en preFixup, igual que hace proton-ge-bin.
    rm $steamcompattool/compatibilitytool.vdf
    cp $src/compatibilitytool.vdf $steamcompattool

    runHook postInstall
  '';

  preFixup = ''
    if [ -f "$steamcompattool/compatibilitytool.vdf" ]; then
      substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
        --replace-fail "proton-EM-${version}" "${steamDisplayName}" \
        --replace-fail "-proton" ""
    fi
  '';

  passthru.updateScript = writeScript "update-proton-em" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    repo="https://api.github.com/repos/Etaash-mathamsetty/Proton/releases"
    version="$(curl -sL "$repo" | jq 'map(select(.prerelease == false)) | .[0].tag_name' --raw-output)"
    update-source-version proton-em "$version"
  '';

  meta = {
    description = "Proton EM (HDR) compatibility tool for Steam Play";
    homepage = "https://github.com/Etaash-mathamsetty/Proton";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ "RickMars-Tech" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
