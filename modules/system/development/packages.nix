{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    #==< Nix >==#
    alejandra
    nil
    #==< Arduino >==#
    arduino-core
    arduino-cli
    arduino-ide
    #==< Rust >==#
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer
    #==< Zig >==#
    zig
    zls
    #==< C/C++ >==#
    clang-tools
    libclang
    cmake
    gccgo
    glib
    glibc
    glibmm
    gdb
    libgcc
    SDL2
    SDL2_image
    SDL2_ttf
    #==< Python >==#
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
        ]
    ))
    ruff
    pyright # LSP adicional para Python
    #==< Octave >==#
    (octaveFull.withPackages (opkgs:
      with opkgs; [
        io
        symbolic
        video
        strings
      ]))
    # KDL
    kdlfmt
    # C/C++
    clang-tools # Incluye clangd
    # JavaScript/TypeScript
    # nodePackages.typescript-language-server
    # nodePackages.prettier
    # Markdown
    # marksman
    # YAML/TOML
    # taplo # TOML LSP
    # yaml-language-server
    # Bash
    # nodePackages.bash-language-server
    # shfmt
    # Docker
    # dockerfile-language-server
    #==< Debug adapters >==#
    lldb
    gdb
    # Others
    flashprog
    pciutils
    usbutils
  ];
}
