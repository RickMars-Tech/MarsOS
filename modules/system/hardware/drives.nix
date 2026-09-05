{
  flake.modules.nixos.drives =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkDefault mkIf;
      rootIsBtrfs = config.fileSystems."/".fsType or "" == "btrfs";
    in
    {
      services = {

        btrfs.autoScrub = mkIf rootIsBtrfs {
          enable = true;
          interval = "monthly";
          fileSystems = [ "/" ];
        };

        # TRIM 4 SSD
        fstrim = {
          enable = true;
          interval = mkIf rootIsBtrfs "monthly";
        };

        # UDisks2 & Automount
        udisks2.enable = true;
        gvfs.enable = true;
        tumbler.enable = true;
        smartd = {
          enable = false;
          autodetect = true;
        };
      };

      # ZRAM & Swap
      zramSwap = {
        enable = true;
        priority = 50;
        memoryPercent = 25;
        algorithm = "zstd";
        swapDevices = 2;
      };

      swapDevices = [
        {
          device = "/swapfile";
          size = 16 * 1024;
          priority = 100;
        }
      ];

      environment.systemPackages = with pkgs; [
        baobab
        woeusb-ng
        popsicle
        usbutils
        iotop
        ncdu
        duf
        f3
        compsize
        btrfs-progs
        smartmontools
        nvme-cli
      ];

      programs = {
        gnome-disks.enable = true;
        udevil.enable = mkDefault false;
      };

      # Disable fsck when BTRFS is used
      # https://wiki.archlinux.org/title/Improving_performance/Boot_process#Filesystem_mounts
      systemd.services.systemd-remount-fs =
        if (!rootIsBtrfs) then
          {
            enable = true;
          }
        else
          {
            enable = false;
          };

      boot.kernelParams = if (!rootIsBtrfs) then [ ] else [ "fsck.mode=skip" ];
    };
}
