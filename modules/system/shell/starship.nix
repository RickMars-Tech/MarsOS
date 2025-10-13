_: {
  programs.starship = {
    enable = true;
    # transientPrompt.enable = true;
    # enableFishIntegration = true;
    # enableInteractive = true;
    # enableTransience = true;
    settings = {
      # format = ''$os$hostname$directory$username$rust$golang$solidity$nodejs(bold blue)$git_branch$git_status[❯](bold yellow)[❯](bold purple)[❯](bold blue) '';
      add_newline = false;

      directory = {
        format = "[$path]($style)[$read_only ]($read_only_style)";
        read_only = " 󰌾";
        truncation_length = 8;
        truncate_to_repo = false;
        style = "blue";
      };

      character = {
        success_symbol = "[λ](bold green)$os$hostname$directory$git_branch$git_status(bold green) [❯](bold yellow)[❯](bold purple)[❯](bold blue)";
        error_symbol = "[λ](bold red)$username$directory(bold red) [❯](bold red)[❯](bold red)[❯](bold red)";
      };

      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol$hostname]($style) ";
        style = "bold green";
        ssh_symbol = "󰇧 ";
        disabled = false;
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
