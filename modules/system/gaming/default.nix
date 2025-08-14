{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
in {
  imports = [
    ./amd.nix
    ./minecraft.nix
    ./nvidiaPro.nix
    ./packages.nix
    ./steam.nix
  ];
  options.mars.gaming = {
    enable = mkEnableOption "Gaming Config" // {default = false;};
    gamemode.enable = mkEnableOption "Feral Gamemode" // {default = false;};
  };

  config = let
    cfg = config.mars.gaming;
  in
    mkIf cfg.enable {
      #=> Gamemode
      programs.gamemode = mkIf (cfg.enable && cfg.gamemode.enable) {
        enable = true;
        enableRenice = true;
        settings = {
          general = {
            renice = 10;
            inhibit_screensaver = 1;
            disable_splitlock = 1;
          };
          cpu = {
            park_cores = "no";
            pin_cores = "yes";
            pin_policy = "core"; # Mejor afinidad
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode Started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode Ended'";
          };
        };
      };

      # Fuerza governor "performance" para gaming
      powerManagement.cpuFreqGovernor = "performance";

      #|==< Udev Gaming >==|#
      services.udev.extraRules = ''
        # Desactivar autosuspend para dispositivos de gaming
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="*", TEST=="power/control", ATTR{power/control}="on"
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="*", TEST=="power/control", ATTR{power/control}="on"
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0738", ATTR{idProduct}=="*", TEST=="power/control", ATTR{power/control}="on"

        # Todos los dispositivos de entrada
        ACTION=="add", SUBSYSTEM=="usb", SUBSYSTEMS=="input", TEST=="power/control", ATTR{power/control}="on"

        # Dispositivos HID (teclados, mouses, gamepads)
        ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="03", TEST=="power/control", ATTR{power/control}="on"
      '';

      boot.kernel.sysctl = {
        # Memoria: bajo swappiness y cache pressure para priorizar RAM
        "vm.swappiness" = 1;
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_ratio" = 15;
        "vm.dirty_background_ratio" = 5;

        # Planificador: tiempo completo para RT y baja migración
        "kernel.sched_rt_runtime_us" = -1; # Sin límite a tareas en tiempo real
        "kernel.sched_migration_cost_ns" = "5000000"; # Reduce migración de tareas

        # Red: optimizado para baja latencia (BBR + buffers altos)
        "net.core.rmem_max" = 536870912;
        "net.core.wmem_max" = 536870912;
        "net.core.netdev_max_backlog" = 5000;
        "net.ipv4.tcp_rmem" = "4096 87380 536870912";
        "net.ipv4.tcp_wmem" = "4096 65536 536870912";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };
    };
}
