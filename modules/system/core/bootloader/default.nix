{ self, ... }:
{
  flake.modules.nixos.bootloader = {
    imports = with self.modules.nixos; [
      limine
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
          "-10"
          "-T0"
        ];
      };
      crashDump.enable = true;
    };
  };
}
