{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.mars.multimediaSoftware = mkEnableOption "Graphics and Design Applications" // {default = false;};
  imports = [
    ./gimp
    ./mpv
    ./obs
  ];
  config = {
  };
}
