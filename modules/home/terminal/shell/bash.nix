{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) hostName;
in {
  programs.bash = {
    completion.enable = true;
    shellAliases = {
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
      # Fastfetch al iniciar
      nerdfetch

      # any-nix-shell para soporte de nix-shell
      # ${pkgs.any-nix-shell}/bin/any-nix-shell bash --info-right | source /dev/stdin
    '';
  };
}
