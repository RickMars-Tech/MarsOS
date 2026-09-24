# Custom packages
final: _: {
  brave-origin = final.callPackage ./brave-origin { };

  # Gaming pkgs
  inherit ((final.callPackage ./hytale { })) hytale-launcher;
  opengoal = final.callPackage ./open-goal { };
  proton-em = final.callPackage ./proton/em { };
  open-now = final.callPackage ./open-now { };
  proton-cachyos-bin = final.callPackage ./proton/cachyos { };

  # Gaming Scripts
  dlss-swapper-dll = final.callPackage ./gaming-scripts/dlss-swapper-dll.nix { };
  dlss-swapper = final.callPackage ./gaming-scripts/dlss-swapper.nix { };
  nouveauPrime = final.callPackage ./gaming-scripts/nouveauPrime.nix { };
  zink-run = final.callPackage ./gaming-scripts/zink-run.nix { };

}
