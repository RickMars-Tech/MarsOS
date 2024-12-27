/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
___  ___                   _____  _____ 
|  \/  |                  |  _  |/  ___|
| .  . |  __ _  _ __  ___ | | | |\ `--. 
| |\/| | / _` || '__|/ __|| | | | `--. \
| |  | || (_| || |   \__ \\ \_/ //\__/ /
\_|  |_/ \__,_||_|   |___/ \___/ \____/ 

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

{ pkgs, ... }: {

    imports = [ # Include the results of the hardware scan.
        ./hardware.nix
        ./modules/default.nix
    ];

#=> Fonts Config
    fonts = {
        packages = with pkgs; [
            noto-fonts
            montserrat
            nerd-fonts.daddy-time-mono
            nerd-fonts.meslo-lg
            nerd-fonts.jetbrains-mono
            nerd-fonts.ubuntu-mono
            source-han-sans
            jost
            material-design-icons
            material-icons
            material-symbols
        ];
        fontconfig = {
            enable = true;
            defaultFonts = {
                monospace = [ "DaddyTimeMono Nerf Font Propo" ];
                serif = [ "Noto Serif" "Source Han Serif" ];
                sansSerif = [ "Noto Sans" "Source Han Sans" ];
            };
        };
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
