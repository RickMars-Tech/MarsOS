{
  config,
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [pkgs.zellij];

  programs.bash.interactiveShellInit = lib.mkIf config.programs.bash.enable ''
    eval "$(zellij setup --generate-auto-start bash)"
  '';
  programs.fish.interactiveShellInit = lib.mkIf config.programs.fish.enable ''
    eval (zellij setup --generate-auto-start fish)
  '';

  xdg.configFile."zellij/config.kdl".text =
    lib.toKDL (import ./settings.nix); # <- lib.toKDL directo

  xdg.configFile."zellij/layouts/dev.kdl".text =
    lib.toKDL (import ./layout.nix);
}
