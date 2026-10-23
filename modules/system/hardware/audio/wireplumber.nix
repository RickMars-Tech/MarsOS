{
  flake.modules.nixos.wireplumber = {
    services.pipewire.wireplumber = {
      enable = true;
      extraConfig = {
        "10-disable-camera"."wireplumber.profiles".main."monitor.libcamera" = "disabled";

        # NVIDIA HDMI (pci 01:00.1): no se usa, se deshabilita.
        "11-disable-alsa-device"."monitor.alsa.rules" = [
          {
            matches = [ { "device.name" = "alsa_card.pci-0000_01_00.1"; } ];
            actions.update-props = {
              "device.disabled" = true;
            };
          }
        ];

        # Salida analógica real (ALC256, pci 35:00.6) como salida "Master".
        "12-configure-master-output"."monitor.alsa.rules" = [
          {
            matches = [ { "node.name" = "alsa_output.pci-0000_35_00.6.analog-stereo"; } ];
            actions.update-props = {
              "node.nick" = "Master";
              "node.disabled" = false;
              "channelmix.normalize" = true;
              "monitor.channel-volumes" = true;
            };
          }
        ];

        # Tarjeta analógica AMD/Realtek (pci 35:00.6) renombrada a "System".
        "13-configure-system-device"."monitor.alsa.rules" = [
          {
            matches = [ { "device.name" = "alsa_card.pci-0000_35_00.6"; } ];
            actions.update-props = {
              "device.description" = "System";
              "device.nick" = "System";
            };
          }
        ];
      };
    };
  };
}
