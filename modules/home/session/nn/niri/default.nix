{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.niri =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkIf;
      uwsm = config.programs.uwsm.enable;
      nvidia = config.hardware.nvidia.enabled;
    in
    {
      # Niri Config
      programs = {
        niri = {
          enable = true;
          useNautilus = true;
          package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
        };
        nautilus-open-any-terminal.enable = true;
      };

      environment.sessionVariables = {
        NIRI_DISABLE_SYSTEM_MANAGER_NOTIFY = mkIf uwsm "1";
        WLR_NO_HARDWARE_CURSORS = mkIf nvidia "1";
      };
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;

        v2-settings = true;
        imports = with self.wrapperModules; [
          niriAnimations
          niriBinds
          niriDebug
          niriEnv
          niriInput
          niriLayout
          niriOutputs
          niriStartup
          niriWindowrules
          niriWorkspaces
        ];
      };
    };
}
