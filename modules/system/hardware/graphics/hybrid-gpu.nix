{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  hybrid = config.mars.graphics.hybridGPU;
in {
  options.mars.graphics.hybridGPU = {
    enable = mkEnableOption "Enable hybrid GPU Config" // {default = false;};
  };
  config = {
    services.supergfxd = {
      enable = hybrid.enable;
      settings.mode = "Integrated";
    };
    environment.sessionVariables = mkIf (hybrid.enable) {
      GAMEMODERUNEXEC = "supergfxctl --mode AsusMuxDgpu"; # Allows you to switch to the dGPU when running FeralGamemode
    };
  };
}
