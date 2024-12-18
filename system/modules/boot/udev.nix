{ ... }: {

    services.udev = {
        enable = true;
        /*packages = with pkgs; [ 
            game-devices-udev-rules
        ];*/
        extraRules = ''

        # SATA Active Link Power Management
            #ACTION=="add", SUBSYSTEM=="scsi_host", KERNEL=="host*", ATTR{link_power_management_policy}="max_performance"

        # HDD
            #ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
            ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/scheduler}="mq-deadline"

        # SSD
            #ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
        # NVMe SSD
            #ACTION=="add|change",KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"

        # Cpu-dma-latency
            DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"

        '';
    };

}
