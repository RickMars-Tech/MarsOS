{config, ...}: {
  imports = [./icons.nix];
  programs.yazi = {
    enable = true;
    settings = {
      theme.mgr = {
        layout = [1 4 3];
        sort_by = "alphabetical";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = false;
        show_symlink = true;
      };
      yazi.preview = {
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "${config.xdg.cacheHome}";
      };
      #theme.flavor = {
      #  dark = "noctalia";
      #};
    };
  };
}
