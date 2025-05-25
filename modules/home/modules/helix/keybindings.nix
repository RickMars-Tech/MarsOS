{pkgs, ...}: {
  programs.helix.settings.keys = {
    normal = {
      esc = ["collapse_selection" "keep_primary_selection"];
      o = [":open ${pkgs.yazi}"];
      H = ":buffer-previous";
      L = ":buffer-next";
      space = {"." = ":fmt";};
      C-y = [
        # Yazi
        ":sh rm -f /tmp/unique-file"
        ":insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file"
        ":insert-output echo '\x1b[?1049h\x1b[?2004h' > /dev/tty"
        ":open %sh{cat /tmp/unique-file}"
        ":redraw"
      ];
      space = {
        e = [
          # Yazi
          ":sh rm -f /tmp/unique-file-h21a434"
          ":insert-output yazi '%{buffer_name}' --chooser-file=/tmp/unique-file-h21a434"
          ":insert-output echo \"x1b[?1049h\" > /dev/tty"
          ":open %sh{cat /tmp/unique-file-h21a434}"
          ":redraw"
        ];
        E = [
          # Yazi
          ":sh rm -f /tmp/unique-file-u41ae14"
          ":insert-output yazi '%{workspace_directory}' --chooser-file=/tmp/unique-file-u41ae14"
          ":insert-output echo \"x1b[?1049h\" > /dev/tty"
          ":open %sh{cat /tmp/unique-file-u41ae14}"
          ":redraw"
        ];
      };
    };
  };
}
