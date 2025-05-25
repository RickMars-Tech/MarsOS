{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./languages.nix
    ./themes.nix
    ./keybindings.nix
  ];

  programs.helix = {
    package = inputs.helix.packages.${pkgs.system}.default;
    enable = true;
    extraPackages = with pkgs; [
      #= Helix Gpt
      helix-gpt
      #= Cfg debug adapter
      lldb
      gdb
      #= Rust
      #clippy
      #rust-analyzer
      #rustfmt
      #= ZIG
      zls
      #= Nix
      alejandra
      nil
      #= Python
      ruff
      #= Kdl
      kdlfmt
    ];
    settings = {
      theme = "base16";

      editor = {
        line-number = "relative";
        bufferline = "multiple";
        auto-pairs = true;
        true-color = true;
        cursorline = true;
        mouse = false;
        color-modes = true;
        lsp = {
          auto-signature-help = false;
          display-messages = true;
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "block";
        };
        indent-guides = {
          render = true;
          character = "│";
          skip-levels = 1;
        };

        soft-wrap = {
          enable = true;
          max-wrap = 25;
          max-indent-retain = 0;
          wrap-indicator = "↪ ";
        };

        file-picker.hidden = false;
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
        };
        statusline = {
          left = ["mode" "spinner" "version-control" "file-name"];
          center = ["file-name"];
          right = [
            "workspace-diagnostics"
            "diagnostics"
            "selections"
            "position"
            "total-line-numbers"
            "spacer"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          separator = "│";
        };
        whitespace.characters = {
          newline = "↴";
          tab = "⇥";
        };
      };
    };
  };
}
