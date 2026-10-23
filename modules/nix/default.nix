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
        # Daemon
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

          # Build users / límites de RAM. Con 7GB de RAM, "auto" (12 jobs)
          # ilimitaba los cores por build y ~12 rustc concurrentes (1.5GB
          # cada uno) ahogaban la máquina: earlyoom mató el build de postilla
          # y casi tumba la sesión COSMIC. 4+4 deja margen para el escritorio.
          max-jobs = 4;
          cores = 4;

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
        nixfmt-rs
        manix
        deadnix
        nix-inspect
      ];
    };
}
