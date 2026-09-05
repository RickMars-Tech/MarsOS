{
  flake.modules.nixos.brave =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        package = pkgs.brave-origin;
        extraOpts = {
          "PasswordManagerEnabled" = false;
          "SpellcheckEnabled" = true;
          "SpellcheckLanguage" = [
            "es-MX"
            "en-US"
          ];
        };
        extensions = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
          "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
          "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
          "khncfooichmfjbepaaaebmommgaepoid" # Unhook
          "gkkkcomfmldkigajkmljnbpiajbpbgdg" # TWP
          "ihcjicgdanjaechkgeegckofjjedodee" # Malwarebytes
        ];
      };
      environment = {
        systemPackages = with pkgs; [
          (brave-origin.override {
            commandLineArgs = "--enable-features=TouchpadOverscrollHistoryNavigation";
            vulkanSupport = true;
          })
        ];
        sessionVariables.NIXOS_OZONE_WL = "1";
      };
    };
}
