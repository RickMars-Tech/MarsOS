{
  config,
  inputs,
  pkgs,
  self,
  lib,
  ...
}: let
  inherit
    (lib)
    concatStringsSep
    mapAttrsToList
    mkDefault
    mapAttrs
    sort
    ;
  registry = mapAttrs (_: flake: {inherit flake;}) inputs;
  nixPath = mapAttrsToList (name: _: "${name}=flake:${name}") inputs;
  nixTag = config.system.nixos.tags;
  nixVersion = config.system.nixos.version;
in {
  imports = [
    ./cache.nix
    ./nh.nix
    ./nix-ld.nix
  ];
  #= Enable Nix-Shell, Flakes and More...
  nix = {
    channel.enable = false;
    # Registry for legacy nix commands
    registry = registry;
    # Pin nixpkgs flake to system nixpkgs
    nixPath = nixPath;
    # Use Lix
    package = pkgs.lixPackageSets.latest.lix;
    settings = {
      auto-optimise-store = true;
      # download-buffer-size = 524288000; # Increases the Download Buffer to prevent it from filling up
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
      automatic = !config.programs.nh.clean.enable;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };
  system = {
    rebuild.enableNg = mkDefault true;

    #= Better nixos generation label
    # https://www.reddit.com/r/NixOS/comments/16t2njf/small_trick_for_people_using_nixos_with_flakes/
    nixos.label = concatStringsSep "." (
      (sort (x: y: x < y) nixTag)
      ++ ["${nixVersion}.${self.sourceInfo.shortRev or "dirty"}"]
    );
  };
}
