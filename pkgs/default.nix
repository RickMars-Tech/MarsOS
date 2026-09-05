# Custom packages
final: prev: {
  brave-origin = final.callPackage ./brave-origin { };

  # Gaming pkgs
  inherit ((final.callPackage ./hytale { })) hytale-launcher;
  opengoal = final.callPackage ./open-goal { };
  proton-em = final.callPackage ./proton/em { };
  proton-cachyos-bin = final.callPackage ./proton/cachyos { };

  # Gaming Scripts
  dlss-swapper-dll = final.callPackage ./gamingScripts/dlss-swapper-dll.nix { };
  dlss-swapper = final.callPackage ./gamingScripts/dlss-swapper.nix { };
  nouveauPrime = final.callPackage ./gamingScripts/nouveauPrime.nix { };
  zink-run = final.callPackage ./gamingScripts/zink-run.nix { };

}
