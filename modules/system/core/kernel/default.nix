{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  version = config.mars.boot.kernel.version;
  gaming = config.mars.gaming;
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
    # Kernel
    boot.kernelPackages =
      if version == "latest"
      then pkgs.linuxPackages_latest
      else if version == "rc"
      then pkgs.linuxPackages_testing
      else pkgs.linuxPackages; # stable its default

    # Scheduler SCX
    services.scx = {
      enable = gaming.enable;
      package = pkgs.scx.rustscheds;
      scheduler = "scx_lavd";
    };
  };
}
