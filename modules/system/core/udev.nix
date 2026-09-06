{
  flake.modules.nixos.udev =
    { pkgs, ... }:
    {
      services.udev = {
        enable = true;

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

          # HDD: BFQ remains the right choice
          ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", \
              ATTR{queue/scheduler}="bfq"

          # SSD: use ADIOS instead of mq-deadline
          ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", \
              ATTR{queue/scheduler}="adios"

          # NVMe: use ADIOS instead of kyber
          ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", \
              ATTR{queue/scheduler}="adios"

          # HDPARM (Ahorro de energía para HDD)
          ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", \
              ATTRS{id/bus}=="ata", RUN+="${pkgs.hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"
        '';
      };
    };
}
