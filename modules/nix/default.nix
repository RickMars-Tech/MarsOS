{
  self,
  lib,
  ...
}:
let
  inherit (lib)
    mkDefault
    ;
in
{
  flake.modules.nixos.nix =
    { pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        nix-ld
        overlays
      ];
      programs = {
        nh = {
          enable = true;
          clean = {
            enable = true;
            dates = "weekly";
            extraArgs = "--keep 5 --keep-since 7d";
          };
        };
      };
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.permittedInsecurePackages = [
        "electron-40.10.5"
      ];

      nix = {
        #= Daemon
        daemonIOSchedPriority = mkDefault 7;
        daemonCPUSchedPolicy = mkDefault "batch";
        daemonIOSchedClass = mkDefault "idle";

        channel.enable = false;
        settings = {
          auto-optimise-store = true;
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          substituters = [ "https://hyprland.cachix.org" ];
          trusted-substituters = [ "https://hyprland.cachix.org" ];
          trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
          # Required so non-root users are allowed to use the above substituter/keys.
          # Use @wheel for all sudo users, or list your username explicitly.
          trusted-users = [
            "root"
            "@wheel"
          ];

          # Cache
          extra-substituters = [
            "https://nix-community.cachix.org"
          ];

          extra-trusted-public-keys = [
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
          substitute = true;
          builders-use-substitutes = true;

          # Build isolation and security
          sandbox = true;
          restrict-eval = false;

          # Advanced cache settings
          narinfo-cache-negative-ttl = 3600;
          narinfo-cache-positive-ttl = 432000;

          # Build log optimization
          log-lines = 100;
          show-trace = false;

          # Build users
          max-jobs = "auto";

          # Keep build dependencies
          keep-derivations = true;
          keep-outputs = true;
        };
        gc.automatic = false;
      };

      # Nix tooling
      environment.systemPackages = with pkgs; [
        nixd
        statix
        nixfmt
        manix
        deadnix
        nix-inspect
      ];
    };
}
