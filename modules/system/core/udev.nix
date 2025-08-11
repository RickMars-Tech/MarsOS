{pkgs, ...}: {
  services.udev = {
    enable = true;
    packages = with pkgs; [
      game-devices-udev-rules
    ];
    extraRules = ''
      # For Programing ESP32/Arduino Like Boards
      KERNEL=="ttyACM[0-9]*", MODE="0660", GROUP="dialout"
      KERNEL=="ttyUSB[0-9]*", MODE="0660", GROUP="dialout"
    '';
  };
}
