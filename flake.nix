{
  description = "My NixOS Configuration";

  inputs = {
    #==> Determinate Nix <==#
    magic-nix-cache.url = "https://flakehub.com/f/DeterminateSystems/magic-nix-cache/*.tar.gz";
    nix = {
      url = "https://flakehub.com/f/DeterminateSystems/nix/2.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";

    #==> Rust <==#
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #==> Flatpak <==#
    nix-flatpak.url = "https://flakehub.com/f/gmodena/nix-flatpak/*.tar.gz";

    #==> Home & Stylix <==#
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "https://flakehub.com/f/danth/stylix/*.tar.gz";

    #==> Hyprland <==#
    hyprland.url = "github:hyprwm/Hyprland";

    #==> NVF <==#
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nix-flatpak,
    home-manager,
    nix,
    nixpkgs,
    stylix,
    self,
    ...
  }: let
    system = "x86_64-linux";
    username = "rick";
    name = "Rick";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      #inherit lib;
      modules = [
        #==> Nix <==#
        ./system/configuration.nix
        nix.nixosModules.default

        #==> Flatpak <==#
        nix-flatpak.nixosModules.nix-flatpak

        #==> Stylix <==#
        stylix.nixosModules.stylix

        #==> Home-Manager <==#
        home-manager.nixosModules.home-manager

        #==> System/Home Config <==#
        {
          nixpkgs.config.allowUnfree = true;
          nix.settings = {
            substituters = [
              "https://hyprland.cachix.org"
            ];
            trusted-public-keys = [
              "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            ];
          };
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = import ./home-manager/home.nix;

            extraSpecialArgs = {
              inherit username;
              inherit inputs;
              inherit self;
            };
          };
        }
      ];
      specialArgs = {
        inherit inputs;
        inherit username;
        inherit name;
        inherit self;
      };
    };
  };
}
