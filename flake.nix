{
  inputs = {
    # Core
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    # Dendritic
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    wrapper-modules.url = "github:nix-community/nix-wrapper-modules";

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
