{inputs, ...}: let
  addon = inputs.firefox-addons.packages."x86_64-linux";
in {
  programs.firefox.profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    search = {
      force = true;
      default = "ddg";
      order = ["ddg" "google"];
    };
    extensions = {
      # force = true;
      packages = with addon; [
        bitwarden
        ublock-origin
        sponsorblock
        darkreader
        translate-web-pages
        auto-tab-discard
        user-agent-string-switcher
        return-youtube-dislikes
      ];
    };
  };
}
