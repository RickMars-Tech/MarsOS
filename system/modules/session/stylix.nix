{pkgs, ...}: {
  stylix = {
    enable = true;
    autoEnable = true;
    homeManagerIntegration = {
      followSystem = true;
      autoImport = true;
    };
    image = ../../../home-manager/wal/nix-wallpaper-nineish-dark-gray.png;

    polarity = "dark";

    base16Scheme = {
      # Base colors (Thinkpad Classic)
      "base00" = "#0C0C0C"; # Negro carbón (como el chasis)
      "base01" = "#1A1A1A"; # Gris oscuro (teclado)
      "base02" = "#3D3D3D"; # Gris medio (bordes)
      "base03" = "#5E5E5E"; # Gris claro (texto secundario)

      # Text colors (High-contrast moderno)
      "base04" = "#C0C0C0"; # Gris plata (texto principal)
      "base05" = "#E0E0E0"; # Blanco retro (texto destacado)

      # Acentos (TrackPoint Red + Modern Cyan)
      "base06" = "#FF3030"; # Rojo Thinkpad clásico
      "base07" = "#00CED1"; # Cian moderno (contraste)
      "base08" = "#FF4D4D"; # Rojo error (variación)
      "base09" = "#FFA500"; # Ámbar (advertencias)
      "base0A" = "#32CD32"; # Verde lima (éxito)
      "base0B" = "#20B2AA"; # Verde mar moderno
      "base0C" = "#00BFFF"; # Azul brillante (links)
      "base0D" = "#1E90FF"; # Azul Thinkpad (antiguo logo)
      "base0E" = "#6A5ACD"; # Púrpura suave (UI)
      "base0F" = "#8B0000"; # Rojo oscuro (crítico)
    };

    targets = {
      gnome.enable = true;
    };

    cursor = {
      #package = pkgs.apple-cursor;
      #name = "macOS";
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 24;
    };

    fonts = {
      sizes = {
        applications = 12;
        terminal = 13;
        desktop = 11;
        popups = 12;
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.noto;
        name = "NotoSerif NF";
        #package = pkgs.inter;
        #name = "Inter";
      };

      serif = {
        package = pkgs.nerd-fonts.noto;
        name = "NotoSerif NFP";
        #package = pkgs.lora;
        #name = "Lora";
      };
    };
  };
}
