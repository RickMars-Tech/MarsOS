{
  lib,
  stdenvNoCC,
  fetchurl,
}:

# CachyOS-patched Proton build, bundled at build-time so it is always
# available on a fresh install without relying on Faugus/Lutris auto-download
# (which fails when the user hits the github.com API rate limit).
#
# Upstream: https://github.com/CachyOS/proton-cachyos
# The tarball is extracted into $out and its compatibilitytool.vdf
# already declares display_name = "Proton-CachyOS Latest", which is the
# exact identifier Faugus's runner lookup expects.
#
# To bump: update `version`, `dateTag`, download the asset, compute the
# sha256 (`nix-prefetch-url <url>`), and paste it into `hash`.
let
  version = "11.0-20260602-slr";
  tag = "cachyos-${version}";
in
stdenvNoCC.mkDerivation {
  pname = "proton-cachyos-bin";
  inherit version;

  src = fetchurl {
    url = "https://github.com/CachyOS/proton-cachyos/releases/download/${tag}/proton-cachyos-${version}-x86_64.tar.xz";
    hash = "sha256-qC20cEi08yTC1RMu8mCXbrIf+yl1QBUpFSKzRKzmZTg=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    tar -xf $src -C $out --strip-components=1

    # Normalize the display_name so Faugus recognizes the dir as
    # "Proton-CachyOS Latest" regardless of what the archive ships.
    if [ -f $out/compatibilitytool.vdf ]; then
      substituteInPlace $out/compatibilitytool.vdf \
        --replace-quiet 'proton-cachyos-${version}-x86_64' 'Proton-CachyOS Latest'
    fi
    runHook postInstall
  '';

  meta = with lib; {
    description = "CachyOS-patched Proton build for Windows games on Linux";
    homepage = "https://github.com/CachyOS/proton-cachyos";
    license = with licenses; [
      bsd3
      lgpl21Plus
    ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
