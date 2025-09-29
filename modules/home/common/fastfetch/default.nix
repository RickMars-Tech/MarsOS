_: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = ../../../../assets/ascii-art/skull.txt;
        color = {"1" = "white";};
      };
      display.separator = "  • ";
      modules = [
        "break"
        {
          type = "title";
          color = {
            user = "magenta";
            at = "white";
            host = "green";
          };
        }
        {
          type = "colors";
          paddingLeft = 1;
          symbol = "circle";
        }
        {
          type = "custom";
          format = "Host";
          outputColor = "blue";
        }
        {
          type = "os";
          key = " ├ ";
          keyColor = "green";
        }
        {
          type = "kernel";
          key = " ├ ";
          format = "{1} {2}";
          keyColor = "green";
        }
        {
          type = "packages";
          key = " └ 󰏖";
          keyColor = "green";
        }
        # Hardware
        {
          type = "custom";
          format = "Hardware";
          outputColor = "blue";
        }
        {
          type = "cpu";
          key = " ├ ";
          showPeCoreCount = true;
          format = "{1}";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = " ├ 󰧨";
          keyColor = "green";
        }
        {
          type = "memory";
          key = " ├ ";
          keyColor = "green";
        }
        {
          type = "swap";
          key = " ├ ";
          keyColor = "green";
        }
        {
          type = "disk";
          key = " └ ";
          keyColor = "green";
        }
        # Shell/Terminal
        {
          type = "custom"; # Operative System
          format = "Shell";
          outputColor = "blue";
        }
        {
          type = "shell";
          key = " ├ ";
          keyColor = "green";
        }
        {
          type = "terminal";
          key = " └ ";
          keyColor = "green";
        }
      ];
    };
  };
}
