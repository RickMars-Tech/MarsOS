{ inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  options.flake = inputs.flake-parts.lib.mkSubmoduleOptions {
    wrapperModules = inputs.nixpkgs.lib.mkOption {
      type = inputs.nixpkgs.lib.types.attrsOf inputs.nixpkgs.lib.types.deferredModule;
      default = { };
    };
  };

  config = {
    # Solo Linux: nixfmt-rs (formatter) no existe en darwin, y evaluar
    # x86_64-darwin rompía `nix flake show --all-systems`.
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    perSystem = { pkgs, ... }: {
      formatter = pkgs.nixfmt-rs;
    };
  };
}
