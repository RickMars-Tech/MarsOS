{config, ...}: let
  font = config.stylix.fonts;
in {
  programs.ghostty.settings = {
    font-size = font.sizes.terminal;
    font-family = font.monospace.name;

    shell-integration-features = "cursor,sudo,title";
    background-opacity = 0.90;
    keybind = [
      "alt+shift+q=close_tab"
      "alt+shift+h=previous_tab"
      "alt+shift+l=next_tab"
    ];
  };
}
