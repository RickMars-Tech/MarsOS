_: let
  # Función helper para comandos de Yazi
  yaziCommand = chooserFile: directory: [
    ":sh rm -f ${chooserFile}"
    ":insert-output yazi '${directory}' --chooser-file=${chooserFile}"
    ":insert-output echo '\\x1b[?1049h\\x1b[?2004h' > /dev/tty"
    ":open %sh{cat ${chooserFile}}"
    ":redraw"
  ];
in {
  programs.helix.settings.keys = {
    normal = {
      # Escape mejorado
      esc = ["collapse_selection" "keep_primary_selection"];

      # Buffer navigation
      H = ":buffer-previous";
      L = ":buffer-next";

      # Quick commands
      space = {
        "." = ":format";
        "," = ":config-reload";

        # File operations con Yazi
        e = yaziCommand "/tmp/helix-yazi-current" "%{buffer_name}";
        E = yaziCommand "/tmp/helix-yazi-workspace" "%{workspace_directory}";

        # Git operations
        g = {
          g = ":sh lazygit";
          s = ":sh git status";
          a = ":sh git add %{buffer_name}";
          c = ":sh git commit";
          p = ":sh git push";
          l = ":sh git log --oneline -10";
        };

        # LSP actions mejoradas
        l = {
          a = "code_action";
          r = "rename_symbol";
          # R = "references";
          d = "goto_definition";
          D = "goto_declaration";
          i = "goto_implementation";
          t = "goto_type_definition";
          h = "hover";
          s = "symbol_picker";
          S = "workspace_symbol_picker";
          # f = "format";
        };

        # Búsqueda y navegación
        "/" = "global_search";
        "?" = "rsearch";
        "*" = ["move_char_right" "move_prev_word_start" "move_next_word_end" "search_selection" "search_next"];

        # Diagnósticos
        d = {
          n = "goto_next_diag";
          p = "goto_prev_diag";
          d = "diagnostics_picker";
        };

        # Windows y splits
        w = {
          v = ":vsplit";
          s = ":hsplit";
          q = ":quit";
          # o = ":only";
        };

        # Terminal
        t = ":sh $SHELL";
      };

      # Navegación mejorada
      "C-u" = ["half_page_up"];
      "C-d" = ["half_page_down"];
      "C-b" = ["page_up"];
      "C-f" = ["page_down"];

      # Selección rápida
      "C-a" = "select_all";

      # Comentarios
      "C-/" = "toggle_comments";

      # Quick save
      "C-s" = ":write";
    };

    insert = {
      # Navegación en insert mode
      "C-h" = "move_char_left";
      "C-j" = "move_visual_line_down";
      "C-k" = "move_visual_line_up";
      "C-l" = "move_char_right";

      # Save
      "C-s" = ":write";
    };

    select = {
      # Comentarios en select mode
      "C-/" = "toggle_comments";
    };
  };
}
