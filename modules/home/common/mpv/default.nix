{
  imports = [./config.nix ./binds.nix];

  xdg.configFile."mpv/shaders" = {
    source = ./shaders;
    recursive = true;
  };
}
