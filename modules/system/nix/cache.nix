_: {
  nix.settings = {
    substitute = true;
    builders-use-substitutes = true;
    extra-substituters = [
      "https://install.determinate.systems"
      "https://nix-community.cachix.org"
      "https://chaotic-nyx.cachix.org"
      "https://anyrun.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
}
