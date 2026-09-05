{
  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Dendritic
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # Declarative disk
    disko.url = "github:nix-community/disko";

    # "Home Management"
    hjem.url = "github:feel-co/hjem";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      inputs.import-tree [
        ./modules
        ./hosts
      ]
    );

}
