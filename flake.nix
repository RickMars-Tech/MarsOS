{
  description = "My NixOS Configuration";

  inputs = {
    #|==< Determinate Nix >==|#
    magic-nix-cache.url = "https://flakehub.com/f/DeterminateSystems/magic-nix-cache/*.tar.gz";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.0.tar.gz";
    nix = {
      url = "https://flakehub.com/f/DeterminateSystems/nix/2.*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #|==< Nyx >==|#
    chaotic.url = "https://flakehub.com/f/chaotic-cx/nyx/*.tar.gz";

    #|==< Home & Stylix >==|#
    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "https://flakehub.com/f/danth/stylix/*.tar.gz";

    #|==< Rust >==|#
    fenix = {
      url = "https://flakehub.com/f/nix-community/fenix/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #|==< NiriWM >==|
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #|==< Wezterm >==|#
    #wezterm.url = "github:wez/wezterm?dir=nix";

    #|==< Helix >==|#
    helix.url = "github:helix-editor/helix";

    #|==< Yazi >==|#
    yazi.url = "github:sxyazi/yazi";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://chaotic-nyx.cachix.org"
      "https://helix.cachix.org"
      "https://yazi.cachix.org"
      #"https://wezterm.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      #"wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
    ];
  };

  outputs = inputs @ {
    chaotic,
    fenix,
    home-manager,
    niri,
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
    packages.x86_64-linux.default = fenix.packages.x86_64-linux.minimal.toolchain;
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        #|==< Nix >==|#
        ./modules/base.nix
        nix.nixosModules.default

        #|==< Nyx >==|#
        chaotic.nixosModules.default

        #|==< Stylix >==|#
        stylix.nixosModules.stylix

        #|==< Home-Manager >==|#
        home-manager.nixosModules.home-manager

        #|==< System && Home-Manager Config >==|#
        {
          _module.args = {inherit inputs;};
          nixpkgs.config.allowUnfree = true;
          #nix.settings = {
          #};
          home-manager = {
            useGlobalPkgs = false; #= It could not be used together with overrides in the future.
            useUserPackages = true;
            users.${username} = import ./modules/home/default.nix;

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
