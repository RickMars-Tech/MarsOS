{
  inputs,
  lib,
  ...
}: {
  imports = [./cache.nix];
  #= Enable Nix-Shell, Flakes and More...
  nix = {
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 524288000; # Increases the Download Buffer to prevent it from filling up
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Build isolation and security
      sandbox = true;
      restrict-eval = false;

      # Advanced cache settings
      narinfo-cache-negative-ttl = 3600;
      narinfo-cache-positive-ttl = 432000;

      # Build log optimization
      log-lines = 100;
      show-trace = false;

      # Allow users in the wheel group to use nix
      trusted-users = ["root" "@wheel"];

      # Build users
      max-jobs = "auto";

      # Keep build dependencies
      keep-derivations = true;
      keep-outputs = true;
    };
    #= Clean Nix
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    # Registry for legacy nix commands
    registry = (lib.mapAttrs (_: flake: {inherit flake;})) inputs;

    # Pin nixpkgs flake to system nixpkgs
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  };
}
