{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  imports = [
    ./aliases.nix
    ./bash.nix
    ./bat.nix
    ./fish.nix
    ./skim.nix
    ./starship.nix
    ./zoxide.nix
  ];
  options.mars.shell = {
    bash = mkEnableOption "Enable Bash Shell" // {default = true;};
    fish = mkEnableOption "Enable Fish Shell" // {default = false;};
  };

  config = {
    # Shell/CLI programs
    environment.systemPackages = with pkgs; [
      gping # Ping, but with a graph
      bottom # Process/System Monitor
      ripgrep # Extended Grep
      eza # Replacement for ls
      xcp # Extended CP
      dust # Like du but more intuitive
      duf # Disk Usage/Free Utility
      trashy # Alternative to rm and trash-cli
      macchanger # CLI Mac Changer
      zip # Compressor/archiver for creating and modifying zipfiles
      unzip # Extraction utility for archives compressed in .zip format
      gnutar # GNU implementation of the `tar' archiver
      # Goofy Software
      cbonsai
      nerdfetch
      asciiquarium
      sl
    ];
  };
}
