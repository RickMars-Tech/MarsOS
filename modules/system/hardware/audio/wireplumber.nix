{
  services.pipewire.wireplumber = {
    enable = true;
    extraConfig = {
      "10-disable-camera" = {
        "wireplumber.profiles" = {
          main."monitor.libcamera" = "disabled";
        };
      };
      "11-disable-alsa-device" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "device.name" = "alsa_card.pci-0000_03_00.1";
              }
            ];
            actions = {
              update-props = {
                "device.disabled" = true;
              };
            };
          }
        ];
      };
      "12-configure-master-output" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "node.name" = "alsa_output.pci-0000_03_00_.6.pro-output-0";
              }
            ];
            actions = {
              update-props = {
                "node.nick" = "Master";
                "node.disabled" = false;
                "channelmix.normalize" = true;
                "monitor.channel-volumes" = true;
              };
            };
          }
        ];
      };
      "13-configure-system-device" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {
                "device.name" = "alsa_card.pci-0000_03_00.6";
              }
            ];
            actions = {
              update-props = {
                "node.description" = "System";
                "node.name" = "System";
              };
            };
          }
        ];
      };
    };
  };
}
