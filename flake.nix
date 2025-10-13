{
  description = "My NixOS Configuration";

  inputs = {
    #= Core
    # nixpkgs.url = "git+https://github.com/NixOS/nixpkgs?shallow=1&ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #= Lanzaboote(Secure boot)
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #= Home & Theming
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #= Window Manager & Widgets
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: let
    # System & User
    system = "x86_64-linux";
    username = "rick";
    name = "Rick";
    extraSpecialArgs = {
      inherit system username inputs;
      inherit (inputs) self;
    };
    specialArgs = {
      inherit system username name inputs;
      inherit (inputs) self;
    };

    # Función helper para crear configuraciones de hosts
    mkHost = hostname: extraModules:
      nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          # Configuración específica del host
          ./hosts/${hostname}/default.nix
          ./modules/system/default.nix

          #= NixModules
          # inputs.determinate.nixosModules.default
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.disko.nixosModules.disko
          inputs.stylix.nixosModules.stylix
          inputs.home-manager.nixosModules.home-manager

          # Configuración común de sistema y home-manager
          {
            _module.args = {inherit inputs;};
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [inputs.niri.overlays.niri];

            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              users.${username} = import ./modules/home/default.nix;
              inherit extraSpecialArgs;
            };
          }
        ];
      };

    #= Host's
    hosts = {
      boltz = [
        # Example: specific modules for this host
        # inputs.nixos-hardware.nixosModules.common-cpu-amd
      ];
      rift = [];
      crest = [];
    };
  in {
    #= Configuraciones de hosts generadas automáticamente
    nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hosts;

    #= Formatter
    formatter = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
