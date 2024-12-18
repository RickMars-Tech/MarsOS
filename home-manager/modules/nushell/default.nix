{ ... }: {

    programs.nushell = {
        enable = true;
        shellAliases = {
            git = "gix";
            grep = "rg --color=auto";
            cat = "bat --style=plain --paging=never";
            la = "eza -a --color=always --group-directories-first --grid --icons";
            ls = "eza -al --color=always --group-directories-first --grid --icons";
            ll = "eza -l --color=always --group-directories-first --octal-permissions --icons";
            lt = "eza -aT --color=always --group-directories-first --icons";
            tree = "eza -T --all --icons";
            search = "fzf";
            hw = "hwinfo --short";
            changemac = "macchanger -r";
            resetmac = "macchanger -p";
        };
        environmentVariables = {
            #STARSHIP_SHELL = "nu";
        };
        extraConfig = ''
            $env.config = {
                show_banner: false,
                completions: {
                    case_sensitive: false # case-sensitive completions.
                    quick: false    # set to false to prevent auto-selecting completions.
                    partial: true    # set to false to prevent partial filling of the prompt.
                    algorithm: "fuzzy"    # prefix or fuzzy.
                }
            }
        '';
        configFile = {
            text = ''
                # zellij
                def start_zellij [] {
                    if 'ZELLIJ' not-in ($env | columns) {
                        if 'ZELLIJ_AUTO_ATTACH' in ($env | columns) and $env.ZELLIJ_AUTO_ATTACH == 'true' {
                            zellij attach -c
                        } else {
                            zellij
                        }

                        if 'ZELLIJ_AUTO_EXIT' in ($env | columns) and $env.ZELLIJ_AUTO_EXIT == 'true' {
                            exit
                        }
                    }
                }
                fastfetch
                start_zellij
            '';
        };
    };

}
