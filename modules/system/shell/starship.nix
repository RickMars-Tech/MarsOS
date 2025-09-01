_: {
  programs.starship = {
    enable = true;
    # transientPrompt.enable = true;
    # enableFishIntegration = true;
    # enableInteractive = true;
    # enableTransience = true;
    settings = {
      add_newline = false;

      directory = {
        truncation_length = 8;
        truncate_to_repo = false;
        style = "blue";
      };

      character = {
        success_symbol = "[λ](bold green)$username$directory(bold green)";
        error_symbol = "[λ](bold red)$username$directory(bold red)";
      };

      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "(bright-white) ";
        bash_indicator = "(bright-white) ";
      };

      nix_shell = {
        symbol = "";
        format = "[$symbol$name]($style) ";
        style = "bright-purple bold";
      };

      package.disabled = true;
    };
  };
}
