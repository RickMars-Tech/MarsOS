{
  flake.modules.nixos.core =
    { self, ... }:
    {
      imports = with self.modules.nixos; [
        kernel

        # uutils # Experimental

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
