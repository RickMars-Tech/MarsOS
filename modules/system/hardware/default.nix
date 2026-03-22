{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce;
in {
  imports = [
    ./asus.nix
    ./audio
    ./cpu
    ./graphics
    ./drives.nix
    ./powerManagement.nix
    ./thinkpad.nix
  ];

  hardware = {
    enableAllFirmware = mkDefault true; # Enable Proprietary Firmware
    enableAllHardware = mkDefault true;
    enableRedistributableFirmware = mkForce true; # Allow CPU microcode updates
    firmware = with pkgs; [linux-firmware];
    firmwareCompression = "zstd";
  };
  environment.systemPackages = with pkgs; [
    # Redragon Mouses
    mouse_m908
    # PC monitoring
    mission-center
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
  ];
}
