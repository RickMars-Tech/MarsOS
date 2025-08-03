{
  lib,
  config,
  ...
}: {
  imports = [
    ./amd.nix
    ./nvidia.nix
    ./intel.nix
  ];

  options.mars.graphics.enable = lib.mkEnableOption "Enable graphics" // {default = true;};

  config = lib.mkIf (config.mars.graphics.enable) {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
