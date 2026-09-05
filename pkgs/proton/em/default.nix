{
  fetchzip,
  lib,
  proton-ge-bin,
}:
let
  steamDisplayName = "Proton EM";
in
(proton-ge-bin.override {
  inherit steamDisplayName;
}).overrideAttrs
  (
    finalAttrs: _: {
      pname = "proton-em";
      version = "10.0-37";

      src = fetchzip {
        url = "https://github.com/Etaash-mathamsetty/Proton/releases/download/EM-${finalAttrs.version}-HDR/proton-EM-${finalAttrs.version}-HDR.tar.xz";
        hash = "sha256-yap/7G6TeJ9vMtc5H/iWu8w3sM8mI6762G+K2JzSlgk=";
      };

      preFixup = ''
        substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
          --replace-fail "proton-EM-${finalAttrs.version}" "${steamDisplayName}"
        substituteInPlace "$steamcompattool/compatibilitytool.vdf" \
          --replace-fail "-proton" ""
      '';

      passthru.updateScript = lib.writeScript "update-proton-em" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p curl jq common-updater-scripts
        repo="https://api.github.com/repos/Etaash-mathamsetty/Proton/releases"
        version="$(curl -sL "$repo" | jq 'map(select(.prerelease == false)) | .[0].tag_name' --raw-output)"
        update-source-version proton-em "$version"
      '';

      meta = {
        inherit (proton-ge-bin.meta)
          description
          license
          platforms
          sourceProvenance
          ;
        homepage = "https://github.com/Etaash-mathamsetty/Proton";
        maintainers = [ "RickMars-Tech" ];
      };
    }
  )
