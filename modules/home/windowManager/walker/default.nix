_: {
  imports = [./style.nix ./layout.nix];
  services.walker = {
    enable = true;
    systemd.enable = true;
  };
}
