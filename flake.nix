{
  description = "My NixOS Configuration";

  inputs = {

    nix = {
      url = "https://flakehub.com/f/DeterminateSystems/nix/2.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
    #nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.636292.tar.gz";

    nix-flatpak.url = "https://flakehub.com/f/gmodena/nix-flatpak/*.tar.gz";

    magic-nix-cache.url = "https://flakehub.com/f/DeterminateSystems/magic-nix-cache/*.tar.gz";

    fenix = {
      url = "https://flakehub.com/f/nix-community/fenix/0.1.2064.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "https://flakehub.com/f/danth/stylix/*.tar.gz";

    hyprland.url = "github:hyprwm/Hyprland";

  };

  outputs =
    inputs@{
      fenix,
      nix-flatpak,
      home-manager,
      nix,
      nixpkgs,
      #nixpkgs-stable,
      stylix,
      self,
      ...
    }:
    let

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      #pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      lib = nixpkgs.lib;
      username = "rick";
      name = "Rick";

    in
    {

      packages.x86_64-linux.default = fenix.packages.x86_64-linux.minimal.toolchain;
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        inherit lib;
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
          {
            nixpkgs.config.allowUnfree = true;
            _module.args = { inherit inputs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              inherit username;
              inherit inputs;
              inherit self;
            };
          }
        ];
        specialArgs = {
          inherit inputs;
          #inherit pkgs-stable;
          inherit username;
          inherit name;
          inherit self;
        };
      };
    };
}
