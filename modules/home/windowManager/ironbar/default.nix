{inputs, ...}: {
  imports = [
    inputs.ironbar.homeManagerModules.default
    ./config.nix
    ./style.nix
  ];
  programs.ironbar = {
    enable = true;
    systemd = true;
  };
}
