{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) hostName;
in {
  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellAbbrs = {
      #= Nix
      use = "nix shell nixpkgs#";
      snowboot = "nh os boot . #${hostName}";
      snowswitch = "nh os switch . #${hostName}";
      snowtest = "nh os test . #${hostName}";
      snowclean = "nh clean all --ask";

      #= See Hardware Info
      hw = "hwinfo --short";
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
