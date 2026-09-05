{
  flake.modules.nixos.amdcpu =
    { config, ... }:
    {
      hardware.cpu.amd.updateMicrocode = true;
      boot = {
        kernelModules = [
          "zenpower"
        ];
        kernelParams = [
          "amd_pstate=active"
        ];
        extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
        blacklistedKernelModules = [
          "k10temp"
          "sp5100_tco"
        ];
      };
    };
}
