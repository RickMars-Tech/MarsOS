{
  flake.modules.nixos.amdcpu = {
    hardware.cpu.amd.updateMicrocode = true;
    boot = {
      kernelModules = [
        # k10temp is the in-tree driver and the only one that supports this CPU
        # (family 19h). zenpower is out-of-tree and logs
        # "Unsupported CPU family=19h model=44h" on every boot.
        "k10temp"
      ];
      kernelParams = [
        "amd_pstate=passive"
      ];
      blacklistedKernelModules = [
        "sp5100_tco"
      ];
    };
  };
}
