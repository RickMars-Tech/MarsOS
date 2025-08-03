{osConfig, ...}: let
  inherit (osConfig.networking) hostName; # osConfig lets you use System NixOS config on Home-Manager
  rebuildCommand = "sudo nixos-rebuild --flake .#${hostName}";
in {
  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellAbbrs = {
      # #= Nix
      use = "nix shell nixpkgs#";
      snowboot = "${rebuildCommand} boot";
      snowswitch = "${rebuildCommand} switch";
      snowtest = "${rebuildCommand} test";
    };
    shellAbbrs = {
      hw = "hwinfo --short"; #= See Hardware Info
    };
    shellAliases = {
      #= Stats
      ping = "gping";
      top = "btm";
      fetch = "nerdfetch";

      #= Files & Archive Management
      grep = "rg --color=auto";
      cat = "bat --style header --style snip --style changes";
      la = "eza -a --color=always --group-directories-first --grid --icons";
      ls = "eza -al --color=always --group-directories-first --grid --icons";
      ll = "eza -l --color=always --group-directories-first --octal-permissions --icons";
      lt = "eza -aT --color=always --group-directories-first --icons";
      tree = "eza -T --all --icons";
      cd = "z";
      cp = "xcp";
      clc = "clear";
      search = "sk --ansi";
      restore = "trash -r ";
      ls-trash = "trash list";
      clc-trash = "trash empty --all";
      untar = "tar -xvf";
      untargz = "tar -xzvf";
      untarxz = "tar -xJvf";

      #= Disk Usage
      du = "dust"; # Better disk usage analyzer
      df = "duf"; # Better df alternative

      #= See Governor used
      see-governor = "cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";

      #= Macchanger
      changemac = "macchanger -r"; #= Generates a random MAC and sets it
      resetmac = "macchanger -p"; #= Resets the MAC address to the permanent
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
}
