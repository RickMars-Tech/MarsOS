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

          # # Check if our Terminal emulator is Ghostty or Wezterm
          # if [ "$TERM" = "xterm-ghostty" ] || [ "$TERM" = "xterm-256color" ]
          #   # Launch zellij
          #   eval (zellij setup --generate-auto-start fish | string collect)
          # end

          ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
        '';
        # package = self.packages.${pkgs.stdenv.hostPlatform.system}.myFish;
      };
    };
  # perSystem =
  #   { config, pkgs, ... }:
  #   let
  #     inherit (config.networking) hostName;
  #   in
  #   {
  #     packages.myFish = inputs.wrapper-modules.wrappers.fish.wrap {
  #       inherit pkgs;
  #       package = pkgs.fishMinimal;
  #       plugins = with pkgs.fishPlugins; [ bass ];

  #       abbreviations = {
  #         #   # Nix
  #         use = "nix shell nixpkgs#";
  #         snowboot = "nh os boot . #${hostName}";
  #         snowswitch = "nh os switch . #${hostName}";
  #         snowtest = "nh os test . #${hostName}";
  #         snowclean = "nh clean all --ask";
  #         # snowclean = "nh clean all -k3 --nogc --dry";

  #         # See Hardware Info
  #         hw = "hwinfo --short";
  #       };
  #     };
  #   };
}
