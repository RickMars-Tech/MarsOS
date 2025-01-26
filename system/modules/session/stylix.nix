{ pkgs, ... }:
{

  stylix = {
    enable = true;
    autoEnable = true;
    homeManagerIntegration = {
      followSystem = true;
      autoImport = true;
    };
    image = ../../../home-manager/wal/nixos-wallpaper-catppuccin-mocha.png;

    base16Scheme = {
      "base00" = "#15141b"; # Fondo principal, gris oscuro
      "base01" = "#1F1D2A"; # Fondo secundario, morado oscuro
      "base02" = "#2E2B38"; # Resaltado o selección, morado gris
      "base03" = "#6C6B6F"; # Texto secundario, gris morado
      "base04" = "#CDCCCE"; # Texto principal, gris claro
      "base05" = "#EDECEE"; # Texto resaltado, gris muy claro
      "base06" = "#A277FF"; # Morado vibrante, para acentos
      "base07" = "#61FFCA"; # Verde azulado, para acentos
      "base08" = "#FF6767"; # Rojo suave, para errores
      "base09" = "#FFCA85"; # Amarillo suave, para advertencias
      "base0A" = "#A277FF"; # Morado vibrante, para destacar
      "base0B" = "#61FFCA"; # Verde azulado, para éxito
      "base0C" = "#A277FF"; # Morado vibrante, para detalles
      "base0D" = "#61FFCA"; # Verde azulado, para acentos
      "base0E" = "#A277FF"; # Morado vibrante, para elementos UI
      "base0F" = "#FF6767"; # Rojo suave, para acentos
    };

    targets = {
      gnome.enable = true;
    };

    polarity = "dark";

    cursor = {
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
    };

    fonts = {
      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 12;
        popups = 12;
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.noto;
        name = "NotoSerif NF";
      };

      serif = {
        package = pkgs.nerd-fonts.noto;
        name = "NotoSerif NFP";
      };
    };
  };
}
