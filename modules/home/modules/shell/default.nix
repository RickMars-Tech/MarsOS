_: {
  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellAliases = {
      cp = "xcp";
      clc = "clear";
      git = "gix";
      grep = "rg --color=auto";
      cat = "bat --style=plain --paging=never";
      la = "eza -a --color=always --group-directories-first --grid --icons";
      ls = "eza -al --color=always --group-directories-first --grid --icons";
      ll = "eza -l --color=always --group-directories-first --octal-permissions --icons";
      lt = "eza -aT --color=always --group-directories-first --icons";
      tree = "eza -T --all --icons";
      cd = "z";
      search = "sk --ansi";
      #search-alt = "sk --ansi -i -c 'rg --color=always --line-number "{}"'";
      hw = "hwinfo --short";
      changemac = "macchanger -r";
      resetmac = "macchanger -p";
      rm = "trash-put";
      top = "btm";
      fetch = "nerdfetch";
      governor = "bat --style=plain --paging=never /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";
    };
    interactiveShellInit = "
      function fish_greeting
        nerdfetch
      end

      ## Enable Wayland Support for different Applications
      if [ '$XDG_SESSION_TYPE' = 'wayland' ]
        set -gx WAYLAND 1
        set -gx QT_QPA_PLATFORM 'wayland;xcb'
        set -gx GDX_BACKEND 'wayland,x11'
        set -gx MOZ_DBUS_REMOTE 1
        set -gx MOZ_ENABLE_WAYLAND 1
        set -gx _JAVA_AWT_WM_NONREPARENTING 1
        set -gx BEMENU_BACKEND wayland
        set -gx ECORE_EVAS_ENGINE wayland_egl
        set -gx ELM_ENGINE wayland_egl
      end
    ";
    shellInitLast = "
      any-nix-shell fish --info-right | source
      zoxide init fish | source
    ";
  };

  #= Starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

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
