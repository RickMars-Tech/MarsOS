{ pkgs, ... }:

{

  programs.rofi = {
    enable = true;
    cycle = true;
    package = pkgs.rofi-wayland;
    plugins = with pkgs; [
      # HACK: temporary fix until ABI update
      (rofi-calc.override {
        rofi-unwrapped = rofi-wayland-unwrapped;
      })
      rofi-emoji-wayland
    ];
    extraConfig = {
      modi = "drun,calc,window,emoji,run";
      sidebar-mode = true;
      terminal = "footclient";
      show-icons = true;
      kb-remove-char-back = "BackSpace";
      kb-accept-entry = "Control+m,Return,KP_Enter";
      kb-mode-next = "Control+l";
      kb-mode-previous = "Control+h";
      kb-row-up = "Control+k,Up";
      kb-row-down = "Control+j,Down";
      kb-row-left = "Control+u";
      kb-row-right = "Control+d";
      kb-delete-entry = "Control+semicolon";
      kb-remove-char-forward = "";
      kb-remove-to-sol = "";
      kb-remove-to-eol = "";
      kb-mode-complete = "";
      display-drun = "";
      display-run = "";
      display-emoji = "󰞅";
      display-calc = "󰃬";
      display-window = "";
      display-filebrowser = "";
      drun-display-format = "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
      window-format = "{w} · {c} · {t}";
    };
  };
}
