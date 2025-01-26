{ ... }: {

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        TERM = "xterm-256color";
      };
      window = {
        decorations = "None";
        blur = true;
      };
      cursor = {
        style = "block";
      };
    };
  };

}
