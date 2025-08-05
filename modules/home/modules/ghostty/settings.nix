{config, ...}: let
  font = config.stylix.fonts;
in {
  programs.ghostty.settings = {
    font-size = font.sizes.terminal;
    font-family = font.monospace.name;

    shell-integration-features = "cursor,sudo,title";
    window-decoration = false;
    background-opacity = 0.90;
    keybind = [
      "alt+shift+q=close_tab"
      "alt+shift+j=previous_tab"
      "alt+shift+k=next_tab"
    ];
  };
}
