{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.noctalia =
    { pkgs, ... }:
    {
      imports = [ self.modules.nixos.greeter ];
      security.pam.services.noctalia = {
        unixAuth = true;
        enableGnomeKeyring = true;
      };
      environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.noctaliaCore ];
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.noctaliaCore = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        inherit pkgs;
        package = pkgs.noctalia;
      };
    };
}
