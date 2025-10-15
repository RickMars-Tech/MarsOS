{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  version = config.mars.boot.kernel.version;
in {
  imports = [./common.nix];

  options.mars.boot.kernel = {
    version = mkOption {
      type = types.enum ["stable" "latest" "rc"];
      default = "stable";
      description = "Linux Kernel to use";
    };
  };

  config = {
    #|==< Nyx Kernel >==|#
    boot.kernelPackages =
      if version == "latest"
      then pkgs.linuxPackages_latest
      else if version == "stable"
      then pkgs.linuxPackages
      else if version == "rc"
      then pkgs.linux_testing
      else pkgs.linuxPackages;

    #|==< Scheduler SCX >==|#
    services.scx = {
      enable = true;
      package = pkgs.scx.rustscheds;
      scheduler = "scx_lavd";
    };

    services.fwupd.enable = true;
  };
}
