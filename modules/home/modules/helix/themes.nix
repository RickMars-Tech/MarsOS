{config, ...}: let
  cfg = config.stylix.base16Scheme;
in {
  programs.helix = {
    themes.base16 = {
      "ui.menu" = "none";
      "ui.menu.selected" = {modifiers = ["reversed"];};
      "ui.linenr" = {
        fg = cfg.base09;
        bg = cfg.base00;
      };
      "ui.popup" = {modifiers = ["reversed"];};
      "ui.linenr.selected" = {
        fg = cfg.base05;
        bg = cfg.base00;
        modifiers = ["bold"];
      };
      "ui.selection" = {
        fg = cfg.base00;
        bg = cfg.base0D;
      };
      "ui.selection.primary" = {modifiers = ["reversed"];};
      "comment" = {fg = cfg.base04;};
      "ui.statusline" = {
        fg = cfg.base07;
        bg = cfg.base01;
      };
      "ui.statusline.inactive" = {
        fg = cfg.base01;
        bg = cfg.base07;
      };
      "ui.help" = {
        fg = cfg.base02;
        bg = cfg.base07;
      };
      "ui.cursor" = {modifiers = ["reversed"];};
      "variable" = cfg.base09;
      "variable.builtin" = cfg.base0C;
      "constant.numeric" = cfg.base0C;
      "constant" = cfg.base09;
      "attributes" = cfg.base09;
      "type" = cfg.base0D;
      "ui.cursor.match" = {
        fg = cfg.base09;
        modifiers = ["underlined"];
      };
      "string" = cfg.base0B;
      "variable.other.member" = cfg.base0C;
      "constant.character.escape" = cfg.base08;
      "function" = cfg.base0D;
      "constructor" = cfg.base0D;
      "special" = cfg.base0D;
      "keyword" = cfg.base0E;
      "label" = cfg.base0E;
      "namespace" = cfg.base0D;
      "diff.plus" = cfg.base0B;
      "diff.delta" = cfg.base08;
      "diff.minus" = cfg.base08;
      "diagnostic" = {modifiers = ["underlined"];};
      "ui.gutter" = {bg = cfg.base00;};
      "info" = cfg.base0C;
      "hint" = cfg.base0B;
      "debug" = cfg.base08;
      "warning" = cfg.base08;
      "error" = cfg.base08;
    };
  };
}
