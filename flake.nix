{
  description = "A Demonstration of The Power of Nix";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Secure Boot
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Declarative Disk Partitioning and Formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    commonConfig = import ./common.nix;

    lib = nixpkgs.lib.extend (final: _: {
      toKDL = import ./lib/to-kdl.nix {lib = final;};
    });

    commonArgs = {
      inherit (commonConfig) system username fullname;
      inherit inputs self;
    };

    baseModules = [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.disko.nixosModules.disko
      ./modules
      {nixpkgs.config.allowUnfree = true;}
    ];

    mkHost = hostname: extraModules:
      nixpkgs.lib.nixosSystem {
        inherit lib;
        specialArgs = commonArgs // {inherit inputs;};
        system = commonConfig.system;
        modules = baseModules ++ [./hosts/${hostname}] ++ extraModules;
      };

    # Define hosts
    hosts = {
      boltz = [];
      rift = [];
      crest = [];
    };
  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hosts;

    formatter.${commonConfig.system} = nixpkgs.legacyPackages.${commonConfig.system}.alejandra;
  };
}
