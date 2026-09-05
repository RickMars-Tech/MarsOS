{
  flake.modules.nixos.gpu.intel =
    { pkgs, ... }:
    {
      boot = {
        kernelParams = [ "i915.enable_psr=1" ];
        kernelModules = [ "i915" ];
      };
      hardware = {
        intel-gpu-tools.enable = true;
      };
      extraPackages = with pkgs; [
        # Intel media driver (moderno)
        intel-media-driver
        # VAAPI driver (legacy)
        intel-vaapi-driver
        # Intel compute runtime
        intel-compute-runtime
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        intel-media-driver
        intel-vaapi-driver
      ];
    };
}
