{ self, ... }:
{
  flake.modules.nixos.bootloader = {
    imports = with self.modules.nixos; [
      systemd-boot
    ];

    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 3;
      };
      initrd = {
        enable = true;
        verbose = false;
        compressor = "zstd";
        compressorArgs = [
          "-3"
          "-T0"
        ];
      };
      # crashDump reserva 128M de RAM y añade nmi_watchdog=panic +
      # softlockup_panic=1, lo que reinicia/congela el equipo ante un
      # softlockup. En un equipo con 8GB no compensa: desactivado.
      crashDump.enable = false;
    };
  };
}
