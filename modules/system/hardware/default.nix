{ self, ... }:
{
  flake.modules.nixos.hardwareCore =
    {
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkDefault mkForce;
    in
    {
      imports = with self.modules.nixos; [
        power
        audio
        drives
      ];

      hardware = {
        enableAllFirmware = mkDefault true; # Enable Proprietary Firmware
        enableAllHardware = mkDefault true;
        enableRedistributableFirmware = mkForce true; # Allow CPU microcode updates
        firmware = with pkgs; [ linux-firmware ];
        firmwareCompression = "zstd";
        cpu.x86.msr.enable = true;
        graphics = {
          enable = true;
          enable32Bit = true;

          extraPackages = with pkgs; [
            mesa
            mesa-demos
            mesa-gl-headers
            libdrm
            libgbm
            libGL
            vulkan-loader
            vulkan-validation-layers
            vulkan-tools
            vulkan-extension-layer
          ];
          extraPackages32 = with pkgs.driversi686Linux; [
            mesa
            mesa-demos
          ];
        };
      };
      services.fwupd.enable = true;

      # Some Packages
      environment.systemPackages = with pkgs; [
        # Redragon Mouses
        mouse_m908
        # PC monitoring
        zenmonitor
        nvtopPackages.full
        lshw
        cpu-x
        clinfo
        hardinfo2
        hwinfo
        cpuid
        # Multimedia Codecs & Libs
        openh264
        x264
        # H.265/HEVC
        x265
        # WebM VP8/VP9 codec SDK
        libvpx
        # Open, royalty-free, highly versatile audio codec
        libopus
        # MPEG
        lame
        # FFMPEG
        ffmpeg
        # Graphics
        lact
        # mesa
        # mesa-demos
        # mesa-gl-headers
        # libdrm
        libgbm
        libGL
        vulkan-loader
        vulkan-headers
        vulkan-validation-layers
        vulkan-tools
        vulkan-extension-layer
      ];
    };
}
