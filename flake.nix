{
  description = "My NixOS Configuration";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # System tools
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home & Theming
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Window Manager & Extensions
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ironbar = {
      url = "github:JakeStanger/ironbar/v0.17.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "rick";
    fullname = "Rick";

    commonArgs = {
      inherit system username fullname inputs self;
    };

    baseModules = [
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.disko.nixosModules.disko
      inputs.stylix.nixosModules.stylix
      home-manager.nixosModules.home-manager
      ./modules/system
      {
        nixpkgs = {
          hostPlatform = system;
          config.allowUnfree = true;
          overlays = [inputs.niri.overlays.niri];
        };
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = import ./modules/home;
          extraSpecialArgs = commonArgs;
        };
      }
    ];

    mkHost = hostname: extraModules:
      nixpkgs.lib.nixosSystem {
        specialArgs = commonArgs;
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

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
