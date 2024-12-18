{ pkgs, ... }: {

#= Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.rick = {
        isNormalUser = true;
        createHome = true;
        description = "Rick";
        group = "wheel"; # enable 'sudo'
        extraGroups = [
            "video"
            "audio"
            "render"
            "git"
            "games" # Access to some game software. /var/games.
            "gamemode" # Required for 'renicing' via gamemode.
            "storage" # Used to gain access to removable drives such as USB hard drives.
            "pipewire"
            "disk"
            "libvirt"
            "flatpak"
            "networkmanager"
            "kvm"
            "qemu"
            "input"
        ];
        shell = pkgs.nushell; #pkgs.fish;
    };
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

#= Terminal FileManager
    programs.yazi = {
        enable = true;
        package = pkgs.yazi;#pkgs-stable.yazi;
        settings.yazi = {
            manager = {
                sort_by = "natural";
                show_hidden = true;
                show_symlink = true;
            };
            preview = {
                image_filter = "lanczos3";
                image_quality = 60;
                max_width = 600;
                max_height = 900;
                ueberzug_scale = 1;
                ueberzug_offset = [0 0 0 0];
            };
            tasks = {
                micro_workers = 5;
                macro_workers = 10;
                bizarre_retry = 5;
            };
            keymap = "la-latin1";
        };
    };

}
