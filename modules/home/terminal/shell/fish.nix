{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.networking) hostName;
  inherit (lib) mkIf;
  marsFish = config.mars.shell.fish;
in {
  environment.pathsToLink = mkIf marsFish ["/share/fish"];
  programs.fish = {
    enable = marsFish;
    generateCompletions = true;
    shellAbbrs = {
      # Nix
      use = "nix shell nixpkgs#";
      snowboot = "nh os boot . #${hostName}";
      snowswitch = "nh os switch . #${hostName}";
      snowtest = "nh os test . #${hostName}";
      snowclean = "nh clean all --ask";

      # See Hardware Info
      hw = "hwinfo --short";
    };

    interactiveShellInit = ''
      function fish_greeting
        nerdfetch
      end

      # Check if our Terminal emulator is Ghostty or Wezterm
      if [ "$TERM" = "xterm-ghostty" ] || [ "$TERM" = "xterm-256color" ]
        # Launch zellij
        eval (zellij setup --generate-auto-start fish | string collect)
      end

      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
    package = pkgs.fishMinimal;
  };
}
