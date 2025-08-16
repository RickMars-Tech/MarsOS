# https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/bin/pci-latency
{pkgs, ...}: let
  pci-latency = pkgs.callPackage ../../../pkgs/gamingScripts/pciLatency.nix {};
in {
  systemd.services.pci-latency = {
    enable = true;
    description = "Improve the performance and reduce audio latency for sound cards";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pci-latency}/bin/pci-latency";
    };
  };
}
