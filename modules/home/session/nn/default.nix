{ self, ... }:
{
  flake.modules.nixos.nn =
    { pkgs, ... }:
    {
      imports = with self.modules.nixos; [
        niri
        noctalia
        theme
        xdg
      ];

      # Polkit
      security.soteria.enable = true;

      environment.systemPackages = with pkgs; [
        # Wayland utilities
        wl-mirror
        wl-clipboard-rs
        cliphist

        # Applications
        # nautilus
        papers
        file-roller
        swayimg
        sushi
        # amberol
      ];
    };
}
