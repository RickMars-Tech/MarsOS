{config, ...}: {
  imports = [
    ./layout.nix
    ./settings.nix
  ];

  programs.zellij = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    exitShellOnExit = true;
  };
}
