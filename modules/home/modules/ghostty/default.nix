{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [./settings.nix];
  programs.ghostty = {
    enable = true;
    package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
    enableFishIntegration = config.programs.fish.enable;
    installBatSyntax = true;
  };
}
