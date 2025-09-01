_: {
  imports = [
    ./layout.nix
    ./settings.nix
  ];

  programs.zellij = {
    enable = true;
    exitShellOnExit = true;
  };
}
