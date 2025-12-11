{
  inputs,
  # pkgs,
  ...
}: {
  imports = [
    inputs.ironbar.homeManagerModules.default
    ./config.nix
    ./style.nix
  ];
  programs.ironbar = {
    enable = true;
    # package = pkgs.ironbar;
    systemd = true;
  };
}
