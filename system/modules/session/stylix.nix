{ pkgs, ... }: {

  stylix = {
    enable = true;
    autoEnable = true;
    homeManagerIntegration.followSystem = true;
    image = ../../../home-manager/wal/nix-wallpaper-nineish-dark-gray.png;
    base16Scheme = {
      "base00" = "#151515";  /* fondo principal, color oscuro */
      "base01" = "#262626";  /* fondo secundario, gris oscuro */
      "base02" = "#343434";  /* fondo de selección o resaltado */
      "base03" = "#767676";  /* gris medio-oscuro para comentarios */
      "base04" = "#E5E500";  /* amarillo brillante, usado para resaltar */
      "base05" = "#FFFFFF";  /* color del texto en blanco */
      "base06" = "#FFD200";  /* amarillo suave para elementos secundarios */
      "base07" = "#FF6F00";  /* naranja brillante, usado para elementos destacados */
      "base08" = "#FFBA00";  /* naranja claro */
      "base09" = "#FF7F00";  /* naranja oscuro */
      "base0A" = "#CE3D7A";  /* rosa, que contrasta con los naranjas */
      "base0B" = "#3CA88E";  /* verde suave, para un toque más natural */
      "base0C" = "#D8D8D8";  /* gris claro, para texto no principal */
      "base0D" = "#F5F5F5";  /* gris muy claro */
      "base0E" = "#B0B0B0";  /* gris medio, para resaltar detalles sin sobresalir */
      "base0F" = "#FF6347";  /* rojo tomate, un acento cálido y vibrante */
    };
    targets = {
      gnome.enable = false;
      gnome-text-editor.enable = false;
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
        popups = 11;
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
