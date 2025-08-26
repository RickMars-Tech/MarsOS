{pkgs, ...}: {
  imports = [./common.nix];

  #|==< Nyx Kernel >==|#
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #|==< Scheduler SCX >==|#
  services.scx = {
    enable = true;
    package = pkgs.scx.rustscheds;
    scheduler = "scx_lavd";
  };
}
