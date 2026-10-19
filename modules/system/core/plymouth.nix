{
  flake.modules.nixos.plymouth =
    { lib, ... }:
    let
      inherit (lib) mkDefault;
    in
    {
      boot = {
        plymouth = {
          enable = true;
          theme = "bgrt";
        };
        consoleLogLevel = 3;
        initrd.verbose = false;

        kernelParams = [
          # Silent Mode
          "quiet"
          "splash"
          "boot.shell_on_fail"
          "rd.udev.log_priority=3"
          "rd.systemd.show_status=false"
          "udev.log_priority=3"
          "vt.global_cursor_default=0"
        ];
        kernel.sysctl = {
          "vm.dirty_writeback_centisecs" = mkDefault 3000;
        };
      };
    };
}
