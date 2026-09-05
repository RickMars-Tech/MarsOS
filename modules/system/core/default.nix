{
  flake.modules.nixos.core =
    { self, ... }:
    {
      imports = with self.modules.nixos; [
        kernel

        # Core "Base"
        bootloader
        console
        plymouth # comment to disable Plymouth
        security
        systemd
        udev
      ];
    };
}
