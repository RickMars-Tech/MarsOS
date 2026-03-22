{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf optionalString;

  gaming = config.mars.gaming;
  nvidiaPro = config.mars.hardware.graphics.nvidiaPro;
in {
  services.udev = {
    enable = true;
    packages = mkIf gaming.enable (with pkgs; [
      game-devices-udev-rules
    ]);

    extraRules = ''
      # NTSYNC
      KERNEL=="ntsync", MODE="0660", TAG+="uaccess"

      # CPU DMA Latency (Audio)
      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"

      # HPET-Permissions
      KERNEL=="rtc0", GROUP="audio"
      KERNEL=="hpet", GROUP="audio"

      # Serial Devices (Arduino/ESP32)
      KERNEL=="ttyACM[0-9]*", MODE="0660", GROUP="dialout"
      KERNEL=="ttyUSB[0-9]*", MODE="0660", GROUP="dialout"

      # HDD
      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", \
          ATTR{queue/scheduler}="bfq"

      # SSD
      ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", \
          ATTR{queue/scheduler}="mq-deadline"

      # NVMe SSD
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", \
          ATTR{queue/scheduler}="none"

      # HDPARM
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", \
          ATTRS{id/bus}=="ata", RUN+="${pkgs.hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"


        ${optionalString gaming.enable ''
        #|==< Gaming Controllers - Additional Rules >==|#
        # game-devices-udev-rules ya cubre la mayoría, estas son extras

        # Nyxi Wizard 2 - Back buttons para Steam Input
        SUBSYSTEM=="input", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", \
          ENV{ID_INPUT_JOYSTICK}=="1", \
          TAG+="steam-controller", \
          ENV{STEAM_INPUT_ENABLE}="1", \
          RUN+="${pkgs.coreutils}/bin/chmod 666 /dev/input/event%n"

        # Flydigi Vader 4 Pro (dinput mode)
        KERNEL=="hidraw*", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2412", \
          MODE="0666", TAG+="uaccess"
        SUBSYSTEM=="input", ATTRS{idVendor}=="04b4", ATTRS{idProduct}=="2412", \
          ENV{ID_INPUT_JOYSTICK}=="1", \
          TAG+="steam-controller", \
          ENV{STEAM_INPUT_ENABLE}="1"

        # 8BitDo Ultimate 2 (2.4GHz y Bluetooth)
        KERNEL=="hidraw*", ATTRS{idVendor}=="2dc8", ATTRS{idProduct}=="6012", \
          MODE="0660", TAG+="uaccess"
        KERNEL=="hidraw*", KERNELS=="*2DC8:6012*", \
          MODE="0660", TAG+="uaccess"

        # Regla genérica catch-all (por si game-devices-udev-rules falla)
        SUBSYSTEM=="input", ATTRS{name}=="*[Cc]ontroller*", \
          MODE="0666", TAG+="uaccess"
        SUBSYSTEM=="input", ATTRS{name}=="*[Gg]amepad*", \
          MODE="0666", TAG+="uaccess"
      ''}
    '';
  };
}
