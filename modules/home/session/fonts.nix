{
  flake.modules.nixos.fonts =
    { pkgs, ... }:
    {
      fonts = {
        fontconfig = {
          antialias = true;
          hinting = {
            enable = true;
            autohint = false;
            style = "full";
          };
          subpixel = {
            lcdfilter = "default";
            rgba = "rgb";
          };
          cache32Bit = true;
          defaultFonts = {
            monospace = [ "FiraCode Nerd Font Propo" ];
            sansSerif = [ "Montserrat" ];
            serif = [ "Alegreya" ];
            emoji = [ "Noto Color Emoji" ];
          };
        };
        fontDir = {
          enable = true;
          decompressFonts = true;
        };
        # causes more issues than it solves
        enableDefaultPackages = false;

        packages = with pkgs; [
          nerd-fonts.fira-code
          alegreya
          caladea
          montserrat
          nerd-fonts.noto
          nerd-fonts.hasklug
          nerd-fonts.iosevka
          nerd-fonts.jetbrains-mono
          noto-fonts-color-emoji
        ];
      };
    };
}
