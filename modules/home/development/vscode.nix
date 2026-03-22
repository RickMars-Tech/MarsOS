{
  config,
  pkgs,
  ...
}: let
  enableVSC = config.mars.dev.ide.vscode;
in {
  programs.vscode = {
    enable = enableVSC;
    package = pkgs.vscodium-fhs;
  };
}
