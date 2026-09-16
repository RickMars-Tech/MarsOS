{
  flake.modules.nixos.kernel =
    {
      self,
      pkgs,
      ...
    }:
    {
      imports = [ self.modules.nixos.kernelCommon ];
      boot.kernelPackages = pkgs.linuxPackages_latest;

      # Temporal Fix to Radeon 680 DMCU errors on start up
      nixpkgs.overlays = [
        (final: prev: {
          linux-firmware = prev.linux-firmware.overrideAttrs (old: {
            version = "20260916";
            src = final.fetchFromGitLab {
              domain = "gitlab.com";
              owner = "kernel-firmware";
              repo = "linux-firmware";
              rev = "20260916";
              hash = "sha256-VbDTRN/i+a1BrKnDtdDFxanp3BQujBhe9CyWay9GTXY=";
            };
          });
        })
      ];

      hardware.firmware = [ pkgs.linux-firmware ];

    };
}
