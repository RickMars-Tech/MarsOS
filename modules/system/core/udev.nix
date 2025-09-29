{
  config,
  lib,
  ...
}: let
  inherit (lib) optionalString;
  nvidiaPro = config.mars.graphics.nvidiaPro;
in {
  services.udev = {
    enable = true;
    # packages = with pkgs; [
    #   game-devices-udev-rules
    # ];
    extraRules = ''
      # For Programing ESP32/Arduino Like Boards
      KERNEL=="ttyACM[0-9]*", MODE="0660", GROUP="dialout"
      KERNEL=="ttyUSB[0-9]*", MODE="0660", GROUP="dialout"

      # Detect SSDs SATA and set optimizations
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", \
        ATTR{queue/scheduler}="none", \
        ATTR{queue/read_ahead_kb}="128", \
        ATTR{queue/nr_requests}="256", \
        ATTR{queue/rq_affinity}="2", \
        ATTR{queue/max_sectors_kb}="1024"

      # NVMe SSDs
      ACTION=="add|change", KERNEL=="nvme[0-9]*n[0-9]*", \
        ATTR{queue/scheduler}="none", \
        ATTR{queue/io_poll}="1", \
        ATTR{queue/io_poll_delay}="0", \
        ATTR{queue/read_ahead_kb}="128", \
        ATTR{queue/nr_requests}="1024", \
        ATTR{queue/rq_affinity}="2"
      ${optionalString nvidiaPro.enable ''
        # NVIDIA device permissions
          KERNEL=="nvidia", GROUP="video", MODE="0660"
          KERNEL=="nvidia*", GROUP="video", MODE="0660"
          KERNEL=="nvidia_modeset", GROUP="video", MODE="0660"
          KERNEL=="nvidia_uvm", GROUP="video", MODE="0660"
          KERNEL=="nvidiactl", GROUP="video", MODE="0660"
      ''}
    '';
  };
}
