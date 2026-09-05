{
  flake.modules.nixos.gaming-optimizations =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services = {
        scx = {
          enable = true;
          package = pkgs.scx.rustscheds;
          scheduler = "scx_rusty";
        };
      };

      boot = {
        kernelParams = [
          "preempt=full"
          "threadirqs"
          "snd_hda_intel.power_save=0"
          "tsc=reliable"
          "clocksource=tsc"
          "usbhid.quirks=0x057e:0x2009:0x80000000" # Fix for Switch Pro Controller
        ];
        kernelModules = [
          "ntsync"
          "uinput" # User input module for virtual devices
          "snd-seq" # For MIDI support in games
          "snd-rawmidi" # For raw MIDI support
          "hid_nintendo" # Nintendo Switch Pro Controller and Joy-Cons support
        ];
        kernel.sysctl = {
          "kernel.split_lock_mitigate" = 0;
          "kernel.sched_autogroup_enabled" = 1;
          # The sysctl swappiness parameter determines the kernel's preference for pushing anonymous pages or page cache to disk in memory-starved situations.
          # A low value causes the kernel to prefer freeing up open files (page cache), a high value causes the kernel to try to use swap space,
          # and a value of 100 means IO cost is assumed to be equal.
          # Yes, 180—with zram it's acceptable to go above 100 because the swapping cost is much lower than with a physical disk. In fact,
          # it's the value recommended by systemd-zram-generator.
          "vm.swappiness" = lib.mkIf config.zramSwap.enable 180; # zramSwap

          # The value controls the tendency of the kernel to reclaim the memory which is used for caching of directory and inode objects (VFS cache).
          # Lowering it from the default value of 100 makes the kernel less inclined to reclaim VFS cache (do not set it to 0, this may produce out-of-memory conditions)
          "vm.vfs_cache_pressure" = 50;

          # Contains, as bytes, the number of pages at which a process which is
          # generating disk writes will itself start writing out dirty data.
          "vm.dirty_bytes" = 268435456;

          # page-cluster controls the number of pages up to which consecutive pages are read in from swap in a single attempt.
          # This is the swap counterpart to page cache readahead. The mentioned consecutivity is not in terms of virtual/physical addresses,
          # but consecutive on swap space - that means they were swapped out together. (Default is 3)
          # increase this value to 1 or 2 if you are using physical swap (1 if ssd, 2 if hdd)
          "vm.page-cluster" = 0;

          # Contains, as bytes, the number of pages at which the background kernel
          # flusher threads will start writing out dirty data.
          "vm.dirty_background_bytes" = 67108864;

          # The kernel flusher threads will periodically wake up and write old data out to disk.  This
          # tunable expresses the interval between those wakeups, in 100'ths of a second (Default is 500).
          "vm.dirty_writeback_centisecs" = 1000;

          # This action will speed up your boot and shutdown, because one less module is loaded. Additionally disabling watchdog timers increases performance and lowers power consumption
          # Disable NMI watchdog
          "kernel.nmi_watchdog" = 0;

          # Enable the sysctl setting kernel.unprivileged_userns_clone to allow normal users to run unprivileged containers.
          "kernel.unprivileged_userns_clone" = 1;

          # Restricting access to kernel pointers in the proc filesystem
          "kernel.kptr_restrict" = 2;

          # Increase netdev receive queue
          # May help prevent losing packets
          "net.core.netdev_max_backlog" = 4096;

          # Set size of file handles and inode cache
          "fs.file-max" = 2097152;
        };
      };
      environment.etc."drirc".text = ''
        <driconf>
           <device>
               <application name=" Default ">
                   <option name=" vblank_mode" value="0" />
               </application>
           </device>
        </driconf>
      '';

    };
}
