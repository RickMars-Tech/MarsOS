{
  description = "My NixOS Configuration";

  inputs = {
    # Core
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    # Determinate Systems
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chaotic Nyx
    chaotic = {
      url = "https://flakehub.com/f/chaotic-cx/nyx/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager & Theming
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "https://flakehub.com/f/danth/stylix/*.tar.gz";

    # Development Tools
    fenix = {
      url = "https://flakehub.com/f/nix-community/fenix/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Window Manager & Widgets
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://install.determinate.systems"
      "https://nix-community.cachix.org"
      "https://chaotic-nyx.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
    ];
  };

  outputs = inputs @ {nixpkgs, ...}: let
    # Sistema y usuario globales
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
        # inherit system;
        inherit specialArgs;
        modules =
          [
            # Configuración específica del host
            ./modules/hosts/${hostname}.nix
            ./modules/system/default.nix

            #= NixModules
            inputs.determinate.nixosModules.default
            inputs.chaotic.nixosModules.default
            inputs.stylix.nixosModules.stylix
            inputs.home-manager.nixosModules.home-manager
            # inputs.bongocat.nixosModules.default

            # Configuración común de sistema y home-manager
            {
              _module.args = {inherit inputs;};
              nixpkgs.config.allowUnfree = true;

              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                users.${username} = import ./modules/home/default.nix;
                inherit extraSpecialArgs;
              };
            }
          ]
          ++ extraModules;
      };

    #= Host's
    hosts = {
      boltz = []; # Sin módulos adicionales
      rift = []; # Sin módulos adicionales
      # Ejemplo para agregar más hosts:
      # laptop = [ ./modules/hosts/laptop-specific.nix ];
    };
  in {
    # Configuraciones de hosts generadas automáticamente
    nixosConfigurations = nixpkgs.lib.mapAttrs mkHost hosts;

    #= Default Packages
    packages.${system}.default = inputs.fenix.packages.${system}.minimal.toolchain;
  };
}
