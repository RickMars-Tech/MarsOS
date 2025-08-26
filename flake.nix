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

    # Lanzaboote(Secure boot)
    lanzaboote = {
      url = "https://flakehub.com/f/nix-community/lanzaboote/0.4.2";
      # Optional but recommended to limit the size of your system closure.
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
    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
            ./hosts/${hostname}/default.nix
            ./modules/system/default.nix

            #= NixModules
            inputs.determinate.nixosModules.default
            inputs.lanzaboote.nixosModules.lanzaboote
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
          ]
          ++ extraModules;
      };

    #= Host's
    hosts = {
      boltz = []; # Extra Modules
      rift = []; # Extra Modules
      crest = []; # Extra Modules
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
