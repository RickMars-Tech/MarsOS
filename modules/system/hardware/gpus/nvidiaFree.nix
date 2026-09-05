{
  flake.modules.nixos.nvidia-free =
    { pkgs, ... }:
    {
      boot = {
        kernelParams = [
          "nouveau.config=NvGspRm=1"
          "nouveau.modeset=1"
        ];
        kernelModules = [
          "nouveau"
          "nvidia_wmi_ec_backlight"
        ];
        blacklistedKernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];
      };
      environment = {
        systemPackages = [
        ];
        sessionVariables = {
          MESA_SHADER_CACHE_MAX_SIZE = "10G";
          __GLX_VENDOR_LIBRARY_NAME = "mesa";
          LIBVA_DRIVER_NAME = "nouveau";
          VDPAU_DRIVER = "nouveau";
        };
      };
      hardware.graphics = {
        extraPackages = with pkgs; [
          libva-vdpau-driver
          libva-utils
          vdpauinfo
          libvdpau-va-gl
        ];
        extraPackages32 = with pkgs.driversi686Linux; [
          libvdpau-va-gl
        ];
      };
    };

  flake.nixosModules.nvidia-prime-free =
    { pkgs, ... }:
    # let
    #   nouveauPrimeRun = pkgs.callPackage ../../../../pkgs/gamingScripts/nouveauPrime.nix { };
    # in
    {
      environment = {
        # Change GPU when use Gamemoderun
        sessionVariables.GAMEMODERUNEXEC = "nouveau-prime-run";

        # NVIDIA Prime utilities are handled by hardware.nvidia.prime.offload.enableOffloadCmd
        # Nouveau Prime utilitie
        systemPackages = [
          pkgs.nouveauPrimeRun
        ];
      };
    };
}
