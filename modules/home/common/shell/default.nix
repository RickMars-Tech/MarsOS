{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./starship.nix
  ];

  #= Shell/CLI programs
  home.packages = with pkgs; [
    any-nix-shell # Multiple Shell support for nix-shell
    # nerdfetch # POSIX*Nix Fetch Script + Nerdfonts
    gping # Ping, but with a graph
    bottom # Process/System Monitor
    ripgrep # Extended Grep
    bat # Cat Clone with Syntax Highlighting
    eza # Replacement for ls
    xcp # Extended CP
    zoxide # Fast cd command
    skim # CLI Fuzzy Finder
    dust # Like du but more intuitive
    duf # Disk Usage/Free Utility
    trashy # Alternative to rm and trash-cli
    git
    # gitoxide # Rust Git
    macchanger # CLI Mac Changer
    zip # Compressor/archiver for creating and modifying zipfiles
    unzip # Extraction utility for archives compressed in .zip format
    gnutar # GNU implementation of the `tar' archiver
    # rar
    # unrar-free
  ];
}
