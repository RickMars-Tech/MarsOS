{...}: {
  boot = {
    kernelModules = [
      "thinkpad-acpi"
    ];
    kernelParams = [
      # Shut Up Linux
      "quiet"
      "splash"
      # Shut Up Systemd
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      # Force enable frame buffer compression on Intel HD(Sandy Bridge and newer).
      "i915.enable_fbc=1"
      # Enable RC6 for energy savings in Intel HD 3000.
      "i915.enable_rc6=7"
      # Remove /dev/mem access restrictions(Needed for Upgrade Coreboot/Libreboot).
      "iomem=relaxed"
      # In case something freezes the System
      "sysrq_always_enabled=1"
      # To prevent some writes to the ssd
      "rootflags=noatime"
      # Vulnerability mitigations
      "mitigations=auto,nosmt"
      "mmio_stale_data=full"
      "hardened_usercopy=on"
      "kfence.sample_interval=100"
      "pti=on"
      # Testing
      "random.trust_cpu=1"
    ];
    # - https://madaidans-insecurities.github.io/guides/linux-hardening.html
    # - https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
    blacklistedKernelModules = [
      # Not used by the system
      "ath3k"
      "nouveau"
      "fprint"
      "ide_core"
      # Obscure network protocols
      "af_802154"
      "decnet"
      "econet"
      "ipx"
      "p8022"
      "p8023"
      "psnap"
      "sctp"
      # Old, rare, or insufficiently audited filesystems
      "f2fs"
      "hfs"
      "hfsplus"
      "jfs"
      "squashfs"
      "udf"
      "ufs"
      # Unused network filesystems
      "cifs"
      "gfs2"
      "ksmbd"
      "nfs"
      "nfsv3"
      "nfsv4"
      # Thunderbolt
      "thunderbolt"
      # Vivid testing driver
      "vivid"
      # Modules that are disabled in hardened but not the default kernel
      "hwpoison_inject"
      "punit_atom_debug"
      "acpi_configfs"
      "slram"
      "phram"
      "floppy"
      "cpuid"
      "evbug"
    ];
    extraModprobeConfig = "
      blacklist iTCO_wdt
      options thinkpad_acpi fan_control=1
      options thinkpad_acpi volume_control=1
      options snd-hda-intel model=thinkpad
    ";
  };
}
