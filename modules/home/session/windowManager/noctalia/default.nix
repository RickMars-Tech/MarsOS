{
  imports = [./module.nix];

  programs.noctalia-shell = {
    enable = true;
    # systemd.enable = false;
  };
}
