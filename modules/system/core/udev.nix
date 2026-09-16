{
  flake.modules.nixos.udev = {
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
      '';
    };
  };
}
