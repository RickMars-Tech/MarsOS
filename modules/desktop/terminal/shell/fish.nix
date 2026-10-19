# { inputs, self, ... }:
{
  flake.modules.nixos.fish-shell =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (config.networking) hostName;
      inherit (lib) getExe;
    in
    {
      environment.pathsToLink = [ "/share/fish" ];
      users.defaultUserShell = config.programs.fish.package;

      programs.fish = {
        enable = true;
        generateCompletions = true;
        shellAbbrs = {
          # Nix
          use = "nix shell nixpkgs#";
          snowboot = "nh os boot . #${hostName}";
          snowswitch = "nh os switch . #${hostName}";
          snowtest = "nh os test . #${hostName}";
          snowclean = "nh clean all --ask";
          # snowclean = "nh clean all -k3 --nogc --dry";

          # See Hardware Info
          hw = "hwinfo --short";
        };

        interactiveShellInit = ''
          function fish_greeting
            ${getExe pkgs.nerdfetch}
          end

          ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
        '';
      };
    };
}
