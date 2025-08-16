{pkgs, ...}: {
  imports = [./common.nix];

  #|==< Nyx Kernel >==|#
  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  #|==< Scheduler SCX >==|#
  services.scx = {
    enable = true;
    package = pkgs.scx_git.rustscheds;
    scheduler = "scx_lavd";
  };
}
