{
  flake.modules.nixos.rust =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        cargo
        rustc
        rustfmt
        clippy
        rust-analyzer
      ];
    };
}
