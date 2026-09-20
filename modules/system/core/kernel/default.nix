{
  flake.modules.nixos.kernel =
    {
      self,
      pkgs,
      ...
    }:
    {
      imports = [ self.modules.nixos.kernelCommon ];
      boot.kernelPackages = pkgs.linuxPackages_latest;
    };
}
