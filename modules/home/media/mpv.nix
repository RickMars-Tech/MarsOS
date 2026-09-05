{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.mpv =
    { pkgs, ... }:
    {
      environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.myMpv ];
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.myMpv = inputs.wrapper-modules.wrappers.mpv.wrap {
        inherit pkgs;
        script = with pkgs.mpvScripts; {
          mpris.path = mpris;
          uosc.path = uosc;
          thumbfast.path = thumbfast;
          sponsorblock.path = sponsorblock;
        };
        "mpv.conf".content = ''
          osc=no
          osd-bar=no
          vo=dmabuf-wayland
          profile=gpu-hq
          volume=100
          volume-max=200
        '';
      };
    };
}
