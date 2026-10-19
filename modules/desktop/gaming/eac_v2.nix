# Planea ser un modulo con configuraciones preestablecidas necesitadas
# para que Easy Anti-Cheat v2 funcione en NixOS
{
  flake.modules.nixos.eac = { lib, ... }: {
    boot.kernelParams = lib.mkForce [
      # IOMMU
      "intel_iommu=on"
      "amd_iommu=on"

      # BPF LSM
      "lsm=landlock,lockdown,yama,integrity,apparmor,bpf"

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
