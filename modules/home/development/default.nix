{ self, ... }:
{
  flake.modules.nixos.devel = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      db
      git
      hx
      opencode
      arduino
    ];

    # Markdown Viewer
    environment.systemPackages = with pkgs; [ mo-viewer ];
  };
}
