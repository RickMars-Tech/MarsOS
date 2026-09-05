{
  flake.modules.nixos.limine =
    { pkgs, ... }:
    {
      boot.loader.limine = {
        enable = true;
        # https://github.com/rose-pine/limine
        style = {
          graphicalTerminal = {
            palette = "191724;eb6f92;9ccfd8;f6c177;31748f;c4a7e7;9ccfd8;e0def4";
            brightPalette = "6e6a86;eb6f92;9ccfd8;f6c177;31748f;c4a7e7;9ccfd8;e0def4";
            background = "191724";
            foreground = "e0def4";
            brightBackground = "6e6a86";
            brightForeground = "e0def4";
          };
          wallpapers = [ ];
        };
        additionalFiles = {
          "efi/memtest86/memtest.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
        };
        extraEntries = "/memtest86
                          protocol: chainload
                          path: boot():///efi/memtest86/memtest86.efi";
      };
    };
}
