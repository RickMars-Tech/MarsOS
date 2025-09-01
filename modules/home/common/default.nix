{lib, ...}: let
  inherit (builtins) filter map readDir pathExists;
  inherit (lib.attrsets) filterAttrs mapAttrsToList;
in {
  imports =
    map (name: ./. + "/${name}")
    (
      filter (
        name:
        # Verifica que existe un default.nix en el subdirectorio
          pathExists (./. + "/${name}/default.nix")
      )
      (
        # Solo nombres de directorios (no archivos)
        mapAttrsToList (name: type: name)
        (filterAttrs (name: type: type == "directory") (readDir ./.))
      )
    );
}
