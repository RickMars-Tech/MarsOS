{pkgs, ...}: let
  hytale-launcher = pkgs.callPackage ../../../../pkgs/hytale/default.nix {};
in {
  environment.systemPackages = [
    hytale-launcher
  ];
}
