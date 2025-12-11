{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) optionals;
  lang = config.mars.dev.languages;
  ide = config.mars.dev.ide;
  flashprog = config.mars.dev.flash.flashprog;
in {
  environment.systemPackages = with pkgs;
    [
      fd
      tree-sitter
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
      nodePackages.bash-language-server
      nodePackages.prettier
      shfmt
      marksman
      taplo # TOML
    ]
    ++ optionals ide.arduino [
      #==< Arduino >==#
      arduino-core
      arduino-cli
      arduino-ide
    ]
    #==< Nix >==#
    ++ optionals lang.nix [
      alejandra
      nil
      deadnix
    ]
    #==< Rust >==#
    ++ optionals lang.rust [
      cargo
      rustc
      rustfmt
      clippy
      rust-analyzer
    ]
    #==< Zig >==#
    ++ optionals lang.zig [
      zig
      zls
    ]
    #==< C/C++ >==#
    ++ optionals lang.cpp [
      clang-tools
      libclang
      cmake
      gccgo
      glib
      glibc
      glibmm
      gdb
      libgcc
      clang-tools # Incluye clangd
      lldb
      gdb
    ]
    #==< Python >==#
    ++ optionals lang.python [
      (python313.withPackages (
        p:
          with p; [
            anyqt
            numpy
            matplotlib
            mathutils
            pyqtdarktheme
            qtawesome
            pyautogui
            pyside6
            pygame
            scipy
          ]
      ))
      ruff
      pyright # LSP adicional para Python
    ]
    #==< Octave >==#
    ++ optionals lang.octave [
      (octaveFull.withPackages (opkgs:
        with opkgs; [
          io
          symbolic
          video
          strings
        ]))
      # KDL
      kdlfmt
    ]
    ++ optionals flashprog [
      # Others
      flashprog
      pciutils
      usbutils
    ];
}
