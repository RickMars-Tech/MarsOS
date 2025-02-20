/*
~~~~~~~~~~~~~~~~~~~

███╗   ██╗██╗██╗  ██╗
████╗  ██║██║╚██╗██╔╝
██╔██╗ ██║██║ ╚███╔╝
██║╚██╗██║██║ ██╔██╗
██║ ╚████║██║██╔╝ ██╗
╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝

~~~~~~~~~~~~~~~~~~~~~
*/
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ./modules/default.nix
  ];

  #=> Fonts Config
  fonts = {
    packages = with pkgs; [
      montserrat
      nerd-fonts.noto
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      nerd-fonts.jetbrains-mono
    ];
  };

  # Set your time zone.
  time.timeZone = "America/Chihuahua";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_MX.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_MX.UTF-8";
    LC_IDENTIFICATION = "es_MX.UTF-8";
    LC_MEASUREMENT = "es_MX.UTF-8";
    LC_MONETARY = "es_MX.UTF-8";
    LC_NAME = "es_MX.UTF-8";
    LC_NUMERIC = "es_MX.UTF-8";
    LC_PAPER = "es_MX.UTF-8";
    LC_TELEPHONE = "es_MX.UTF-8";
    LC_TIME = "es_MX.UTF-8";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  #documentation.nixos.enable = true;
}
