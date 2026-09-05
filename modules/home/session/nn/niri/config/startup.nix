{ self, ... }:
{
  flake.wrapperModules.niriStartup =
    {
      pkgs,
      lib,
      ...
    }:
    {
      config.settings.spawn-sh-at-startup = [
        "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.noctaliaCore} -d"
        "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store"
      ];
    };
}
