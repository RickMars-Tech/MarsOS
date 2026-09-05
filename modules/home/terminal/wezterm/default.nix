{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.wezterm =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myWterm
      ];
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.myWterm = inputs.wrapper-modules.wrappers.wezterm.wrap {
        inherit pkgs;
        "wezterm.lua".content = builtins.readFile ./wezterm.lua;
      };
    };
}
