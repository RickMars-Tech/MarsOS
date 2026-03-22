{pkgs, ...}: let
  configFile = "helix/config.toml";
  toTOML = (pkgs.formats.toml {}).generate;
  languagesTOML = import ./_languages.nix {inherit pkgs;};

  lspPackages = with pkgs; [
    # Language Server Protocol
    astro-language-server
    biome
    marksman
    nil
    tailwindcss-language-server
    vue-language-server

    # Formatters
    alejandra
    oxfmt
    shfmt
  ];

  lspBinPath = pkgs.buildEnv {
    name = "helix-lsp-env";
    paths = lspPackages;
    pathsToLink = ["/bin"];
  };

  helixWithLSP =
    pkgs.runCommand "helix-with-lsp" {
      buildInputs = [pkgs.makeWrapper];
    } ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.helix}/bin/hx $out/bin/hx \
        --prefix PATH : ${lspBinPath}/bin


      for bin in ${pkgs.helix}/bin/*; do
        if [ "$(basename $bin)" != "hx" ]; then
          ln -s $bin $out/bin/$(basename $bin)
        fi
      done
    '';
in {
  environment.systemPackages = [
    helixWithLSP
  ];

  xdg.configFile."${configFile}".source = toTOML "config.toml" {
    theme = "noctalia";
    editor = {
      color-modes = true;
      completion-trigger-len = 1;
      completion-replace = true;
      cursorline = true;
      bufferline = "multiple";
      line-number = "relative";
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      undercurl = true;
      true-color = true;
      soft-wrap.enable = true;
      indent-guides = {
        render = true;
        rainbow-option = "dim";
      };
      inline-diagnostics = {
        cursor-line = "hint";
        other-lines = "error";
        max-diagnostics = 3;
      };
      lsp = {
        display-messages = true;
        display-inlay-hints = true;
      };
      gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
      statusline = {
        left = ["mode" "spacer" "version-control"];
        center = ["file-modification-indicator" "file-name" "spinner"];
        right = ["diagnostics" "selections" "position" "position-percentage" "total-line-numbers"];
        mode = {
          normal = "NORMAL";
          insert = "INSERT";
          select = "SELECT";
        };
      };
      trim-final-newlines = true;
      trim-trailing-whitespace = true;
      whitespace = {
        render = {
          space = "all";
          tab = "all";
          newline = "all";
        };
        characters = {
          space = " ";
          nbsp = "⍽";
          tab = "→";
          newline = " "; #"↴";
          tabpad = "-";
        };
      };
      auto-pairs = true;
      clipboard-provider = "wayland";
    };

    keys.insert = {
      C-h = "move_char_left";
      C-j = "move_line_down";
      C-k = "move_line_up";
      C-l = "move_char_right";
      C-e = "goto_line_end";
      C-b = "goto_line_start";
    };

    keys.normal = {
      A-j = ["extend_to_line_bounds" "delete_selection" "paste_after"];
      A-k = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
      A-h = ["delete_selection" "move_char_left" "paste_before"];
      A-l = ["delete_selection" "move_char_right" "paste_after"];

      C-h = ["jump_view_left"];
      C-j = ["jump_view_down"];
      C-k = ["jump_view_up"];
      C-l = ["jump_view_right"];

      tab = ["goto_next_buffer"];
      S-tab = ["goto_previous_buffer"];

      space = {x = ":buffer-close";};

      space.u = {
        f = ":format";
        w = ":set whitespace.render all";
        W = ":set whitespace.render none";
      };
    };
  };
  xdg.configFile."helix/languages.toml".source = languagesTOML;

  environment.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
}
