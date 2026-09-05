{
  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [
      (import ../../pkgs)
    ];
  };
}
