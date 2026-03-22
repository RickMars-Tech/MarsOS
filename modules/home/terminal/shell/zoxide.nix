{config, ...}: {
  programs.zoxide = {
    enable = true;
    flags = [
      "--no-cmd"
      "--cmd cd"
    ];
    enableFishIntegration = config.programs.fish.enable;
    enableBashIntegration = config.programs.bash.enable;
  };
}
