{pkgs, ...}: {
  #= Pipewire
  #security.rtkit.enable = false; # Real-Time Priority to Processes.
  services.pipewire = {
    enable = true;
    audio.enable = true; # Use as primary sound server
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = {
            main."monitor.libcamera" = "disabled";
          };
        };
      };
    };
    extraConfig = {
      pipewire."91-low-latency" = {
        context.properties = {
          default.clock = {
            rate = 48000;
            quantum = 32;
            min-quantum = 32;
            max-quantum = 32;
          };
        };
      };
      pipewire-pulse."92-low-latency" = {
        context.modules = [
          {
            name = "libpipewire-module-protocol-pulse";
            args = {
              pulse.min.req = "32/48000";
              pulse.default.req = "32/48000";
              pulse.max.req = "32/48000";
              pulse.min.quantum = "32/48000";
              pulse.max.quantum = "32/48000";
            };
          }
        ];
        stream.properties = {
          node.latency = "32/48000";
          resample.quality = 1;
        };
      };
    };
    package = pkgs.pipewire;
  };
  services.pulseaudio.enable = false;

  environment.systemPackages = with pkgs; [
    aubio
    alsa-lib
    alsa-plugins
    alsa-utils
    pavucontrol
    #pwvucontrol
  ];
}
