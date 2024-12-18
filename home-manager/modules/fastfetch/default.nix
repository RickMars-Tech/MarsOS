{ ... }: {

    programs.fastfetch = {
        enable = true;
        settings = {
            logo = {
                source = "nixos_small";
                padding = {
                    right = 1; #top = 1;
                };
            };
            display = {
                size.binaryPrefix = "si";
                separator = "  ";
            };
            modules = [
                {
                    "type" = "title";
                    "format" = "{1}@{2}";
                }
                {
                    "type" = "custom"; # Operative System
                    "format" = "┌──────[  OS  ]";
                    "outputColor" = "blue";
                }
                {
                    "type" = "os";
                    "key" = " ╭─"; # Just get your distro's logo from nerdfonts.com
                }
                {
                    "type" = "kernel";
                    "key" = " ├─";
                    "format" = "{1} {2}";
                }
                {
                    "type" = "packages";
                    "key" = " ╰─󰏖";
                }

                {
                    "type" = "custom"; # HardwareStart
                    "format" = "├──────[  Hardware Information  ]";
                    "outputColor" = "blue";
                }
                {
                    "type" = "cpu";
                    "key" = " ╭─";
                    "showPeCoreCount" = true;
                }
                {
                    "type" = "gpu";
                    "key" = " ├─󰍹";
                }
                {
                    "type" = "disk";
                    "key" = " ├─";
                }
                {
                    "type" = "memory";
                    "key" = " ├─";
                }
                {
                    "type" = "swap";
                    "key" = " ╰─󰯍";
                }

                {
                    "type" = "custom"; #Terminal
                    "format" = "├─────[  Terminal  ]";
                    "outputColor" = "blue";
                }
                {
                    "type" = "shell";
                    "key" = " ╭─";
                }
                {
                    "type" = "terminal";
                    "key" = " ╰─";
                }

                {
                    "type" = "custom"; # InformationEnd
                    "format" = "└──────────────────────────────────────────────┘";
                    "outputColor" = "blue";
                }
                {
                    "type" = "colors";
                    "paddingLeft" = 4;
                    "symbol" = "circle";
                }

            ];
        };
    };

}
