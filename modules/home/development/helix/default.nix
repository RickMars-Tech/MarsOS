{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.hx =
    { pkgs, ... }:
    {
      environment = {
        systemPackages = [
          self.packages.${pkgs.stdenv.hostPlatform.system}.myHx
        ];
        sessionVariables = {
          EDITOR = "hx";
          VISUAL = "hx";
        };
      };
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.myHx = inputs.wrapper-modules.wrappers.helix.wrap {
        inherit pkgs;
        package = pkgs.evil-helix;
        imports = with self.wrapperModules; [
          hxCore
          hxLangs
        ];
      };
    };
}
