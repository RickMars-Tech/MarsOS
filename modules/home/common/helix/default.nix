{pkgs, ...}: {
  imports = [
    ./languages.nix
    ./themes.nix
    ./keybindings.nix
  ];

  home.packages = with pkgs; [
    # Herramientas generales
    fd
    ripgrep
    tree-sitter
    # Git para mejor integración
    gitui
  ];

  programs.helix = {
    package = pkgs.helix;
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "base16";

      editor = {
        auto-completion = true;
        completion-replace = true;
        completion-timeout = 100;
        completion-trigger-len = 1;

        # UI improvements
        line-number = "relative";
        bufferline = "multiple";
        auto-pairs = true;
        true-color = true;
        cursorline = true;
        mouse = false;
        color-modes = true;

        # Scrolling mejorado
        scrolloff = 8; # Mantener 5 líneas visibles arriba/abajo del cursor
        scroll-lines = 3;

        lsp = {
          enable = true;
          snippets = true;
          auto-signature-help = true;
          display-messages = true;
          display-inlay-hints = true;
          display-signature-help-docs = true;
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides = {
          render = true;
          character = "│";
          skip-levels = 1;
        };

        soft-wrap = {
          enable = true;
          max-wrap = 25;
          max-indent-retain = 40;
          wrap-indicator = "↪ ";
          wrap-at-text-width = false;
        };

        file-picker = {
          hidden = false;
          follow-symlinks = true;
          deduplicate-links = true;
          parents = true;
          ignore = true;
          git-ignore = true;
          git-global = true;
          git-exclude = true;
        };

        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "disable";
        };

        # Search configuration
        search = {
          smart-case = true;
          wrap-around = true;
        };

        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = ["workspace-diagnostics"];
          right = [
            "diagnostics"
            "selections"
            "register"
            "position"
            "position-percentage"
            "total-line-numbers"
            "spacer"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
          separator = "│";
        };
        whitespace = {
          characters = {
            newline = "↴";
            tab = "⇥";
            nbsp = "⍽";
            space = "·";
            tabpad = "·";
          };
        };
      };
    };
  };
}
