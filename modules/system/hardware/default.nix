{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkForce;
in {
  imports = [
    ./asus.nix
    ./audio/default.nix
    ./cpu/default.nix
    ./graphics/default.nix
    ./drives.nix
    ./powerManagement.nix
    ./thinkpad.nix
  ];

  hardware = {
    enableAllFirmware = mkDefault true; # Enable Properitary Firmware
    enableAllHardware = mkDefault true;
    enableRedistributableFirmware = mkForce true; # Lemme update my CPU Microcode, alr?!
    firmware = with pkgs; [
      linux-firmware
    ];
    firmwareCompression = "zstd";
  };
  environment.systemPackages = with pkgs; [
    #= PC monitoring
    cpu-x
    clinfo
    glxinfo
    hardinfo2
    hwinfo
    #= Multimedia Codecs & Libs
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
