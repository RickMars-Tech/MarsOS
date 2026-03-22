{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) optionals mkForce; # mkIf;
  amd = config.mars.hardware.graphics.amd;
in {
  systemd = {
    services = {
      NetworkManager-wait-online.wantedBy = mkForce [];
    };

    # Optimize SystemD
    settings.Manager = {
      DefaultTimeoutStartSec = "15s";
      DefaultTimeoutStopSec = "3s";
      DefaultLimitNOFILE = "2048:2097152";
    };
    user.extraConfig = "DefaultLimitNOFILE=1024:1048576";

    # ROCm configuration for AI workloads
    tmpfiles.rules = optionals (amd.compute.enable && amd.compute.rocm) [
      "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
    ];
  };

  # JournalD
  services.journald.extraConfig = ''
    SystemMaxUse=50M
  '';
}
