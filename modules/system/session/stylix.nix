{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    homeManagerIntegration = {
      followSystem = true;
      autoImport = true;
    };
    image = ../../home/wal/berserk.png;

    polarity = "dark";

    base16Scheme = {
      #|==< General Colors >==|#
      "base00" = "#000000"; # (Negro) Background color
      "base01" = "#1A1A1A"; # (Negro/Gris) Lighter Background
      "base02" = "#1F1F1F"; # (Gris Oscuro) Selection Background
      "base03" = "#2B2B2B"; # (Gris )Comments, Invisibles, Line Highlighting
      "base04" = "#606060"; # (Gris) Dark Foreground
      "base05" = "#C7C7C7"; # (White) Default Foreground, Caret, Delimiters, Operators
      "base06" = "#C0C0C0"; # (White) Light Foreground
      "base07" = "#D0D0D0"; # (White) Light Background
      "base08" = "#FF4040"; # (Red) Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      "base09" = "#FF80A0"; # (Pink) Integers, Boolean, Constants, XML Attributes, Markup Link Url
      "base0A" = "#40C0FF"; # (Vibrant Blue) Classes, Markup Bold, Search Text Background
      "base0B" = "#20A0E0"; # (Blue) Strings, Inherited Class, Markup Code, Diff Inserted
      "base0C" = "#A040F0"; # (Purple) Support, Regular Expressions, Escape Characters, Markup Quotes
      "base0D" = "#8040FF"; # (Purple) Functions, Methods, Attribute IDs, Headings
      "base0E" = "#FF60C0"; # (Pink) Keywords, Storage, Selector, Markup Italic, Diff Changed
      "base0F" = "#D02060"; # (Dark Pink) Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    };

    targets = {
      gtk.enable = true;
      gnome.enable = false;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };

    fonts = {
      sizes = {
        applications = 11;
        terminal = 11;
        desktop = 11;
        popups = 12;
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Propo"; # Mono
      };

      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };

      serif = {
        package = pkgs.alegreya;
        name = "Alegreya";
      };
    };
  };

  #|==< Extra Fonts >==|#
  fonts = {
    packages = with pkgs; [
      caladea
      montserrat
      nerd-fonts.noto
      nerd-fonts.fira-code
      nerd-fonts.hasklug
      nerd-fonts.jetbrains-mono
    ];
  };
}
