{lib, ...}: let
  inherit (builtins) filter map readDir pathExists attrNames;
  isDirectory = _: type: type == "directory";
  hasDefault = name: pathExists (./. + "/${name}/default.nix");
in {
  imports =
    map (name: ./. + "/${name}")
    (filter hasDefault (attrNames (lib.filterAttrs isDirectory (readDir ./.))));
}
