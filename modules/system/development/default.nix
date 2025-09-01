_: {
  imports = [
    ./git.nix
    ./packages.nix
    ./vscode.nix
  ];
  options.mars.dev = {
  };
  config = {};
}
