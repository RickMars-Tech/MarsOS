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
          "plymouth.use-simpledrm=1"
          # Silent Mode
          "quiet"
          "splash"
          "nowatchdog"
          "boot.shell_on_fail"
          "systemd.show_status=auto"
          "rd.udev.log_priority=3"
          "udev.log_priority=3"
          "vt.global_cursor_default=0"
        ];
        kernel.sysctl = {
          "vm.dirty_writeback_centisecs" = mkDefault 3000;
        };
      };
    };
}
