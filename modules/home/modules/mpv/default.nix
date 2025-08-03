_: {
  imports = [./config.nix ./bindings.nix];

  xdg.configFile."mpv/shaders" = {
    source = ./shaders;
    recursive = true;
  };
}
