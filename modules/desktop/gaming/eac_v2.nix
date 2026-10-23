# Planea ser un modulo con configuraciones preestablecidas necesitadas
# para que Easy Anti-Cheat v2 funcione en NixOS
{
  flake.modules.nixos.eac = { lib, ... }: {
    # mkAfter (no mkForce): añade los params sin borrar los de otros módulos.
    boot.kernelParams = lib.mkAfter [
      # IOMMU
      "intel_iommu=on"
      "amd_iommu=on"

      # Lockdown
      # does nothing right now. staging-nixos turned on
      "lockdown=integrity"
    ];
    # Disable kexec
    # prefered instead of `security.protectKernelImage`
    # Epic says "explicitly disabled at boot time"
    boot.kernel.sysctl.kernel.kexec_load_disabled = true;
  };
}
