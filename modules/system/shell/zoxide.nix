{config, ...}: {
  programs.zoxide = {
    enable = true;
    flags = ["--cmd cd"];
    enableFishIntegration = config.programs.fish.enable;
  };
}
