{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) hostName;
  rebuildCommand = "sudo nixos-rebuild --flake .#${hostName}";
in {
  programs.fish = {
    enable = true;
    generateCompletions = true;
    # useBabelfish = true;
    shellAbbrs = {
      #= Nix
      use = "nix shell nixpkgs#";
      snowboot = "${rebuildCommand} boot";
      snowswitch = "${rebuildCommand} switch";
      snowtest = "${rebuildCommand} test";
      snowclean = " sudo nix-collect-garbage -d";

      #= See Hardware Info
      hw = "hwinfo --short";
    };
    shellAliases = {
      #= Stats
      ping = "${pkgs.gping}/bin/gping";
      top = "${pkgs.bottom}/bin/btm";
      fetch = "${pkgs.fastfetch}/bin/fastfetch";

      #= Files & Archive Management
      grep = "${pkgs.ripgrep}/bin/rg --color=auto";
      cat = "${pkgs.bat}/bin/bat --style header --style snip --style changes";
      man = "batman";
      la = "${pkgs.eza}/bin/eza -a --color=always --group-directories-first --grid --icons";
      ls = "${pkgs.eza}/bin/eza -al --color=always --group-directories-first --grid --icons";
      ll = "${pkgs.eza}/bin/eza -l --color=always --group-directories-first --octal-permissions --icons";
      lt = "${pkgs.eza}/bin/eza -aT --color=always --group-directories-first --icons";
      tree = "${pkgs.eza}/bin/eza -T --all --icons";
      cp = "${pkgs.xcp}/bin/xcp";
      search = "${pkgs.skim}/bin/sk --ansi";
      restore = "${pkgs.trashy}/bin/trash -r ";
      ls-trash = "${pkgs.trashy}/bin/trash list";
      clc-trash = "${pkgs.trashy}/bin/trash empty --all";
      cd = "z";
      clc = "clear";
      untar = "tar -xvf";
      untargz = "tar -xzvf";
      untarxz = "tar -xJvf";

      #= Disk Usage
      du = "${pkgs.dust}/bin/dust"; # Better disk usage analyzer
      df = "${pkgs.duf}/bin/duf"; # Better df alternative

      #= See Governor used
      see-governor = "cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";

      #= Macchanger
      changemac = "macchanger -r"; #= Generates a random MAC and sets it
      resetmac = "macchanger -p"; #= Resets the MAC address to the permanent
    };

    interactiveShellInit = "
      function fish_greeting
        fastfetch
      end

      if status is-interactive
        eval (zellij setup --generate-auto-start fish | string collect)
      end

      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    ";
  };
}
