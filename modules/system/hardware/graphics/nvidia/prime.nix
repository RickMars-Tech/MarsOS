{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge optionals;

  # Import graphics options
  graphics = config.mars.hardware.graphics;
  # gaming = config.mars.gaming.gamemode or {};
  nvidiaPro = graphics.nvidiaPro;
  nvidiaFree = graphics.nvidiaFree;
  amd = graphics.amd;
  # Import Prime runner scripts
  nouveauPrimeRun = pkgs.callPackage ../../../../../pkgs/gamingScripts/nouveau-prime-run.nix {};
in {
  # GAMEMODERUNEXEC configuration for automatic GPU switching
  environment.sessionVariables = mkMerge [
    # NVIDIA Pro (Privative) - set when nvidiaPro.prime is enabled
    (mkIf (nvidiaPro.enable && nvidiaPro.prime.enable) {
      GAMEMODERUNEXEC = "prime-run";
    })

    # NVIDIA Free (Nouveau)
    (mkIf (nvidiaFree.enable && nvidiaFree.prime.enable && (amd.enable || graphics.intel.enable)) {
      GAMEMODERUNEXEC = "nouveau-prime-run";
    })
  ];

  # System packages for GPU switching utilities
  environment.systemPackages =
    # NVIDIA Prime utilities are handled by hardware.nvidia.prime.offload.enableOffloadCmd
    # Nouveau Prime utilitie
    optionals nvidiaFree.enable [
      nouveauPrimeRun
    ];
}
