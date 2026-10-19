{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.ghostty = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myGhostty
    ];
  };
  perSystem = { pkgs, ... }: {
    packages.myGhostty = inputs.wrapper-modules.wrappers.ghostty.wrap {
      inherit pkgs;
      settings = {
        font-family = "FiraCode Nerd Font Propo";
        font-feature = "-liga";
        app-notifications = "no-clipboard-copy,no-config-reload";
        window-decoration = "none";

        # Blur
        background-blur = true;
        background-opacity = 0.85;
      };
    };
  };
}
