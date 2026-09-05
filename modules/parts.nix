{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  options.flake = inputs.flake-parts.lib.mkSubmoduleOptions {
    wrapperModules = inputs.nixpkgs.lib.mkOption {
      default = { };
    };
  };

  config.systems = [
    "x86_64-linux"
    "x86_64-darwin"
    "aarch64-linux"
    "aarch64-darwin"
  ];
}
