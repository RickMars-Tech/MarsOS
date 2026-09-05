{
  imports = [./module.nix];

  programs.noctalia-shell = {
    enable = true;
    settings = ./noctalia.json;
  };
}
