{ ... }:
{

  programs.nushell = {
    enable = true;
    shellAliases = {
      git = "gix";
      grep = "rg --color=auto";
      cat = "bat --style=plain --paging=never";
      la = "ls -a";
      ll = "ls -l";
      lss = "ls -s";
      lt = "ls -t";
      ld = "ls -D";
      cd = "z";
      search = "zi";
      rm = "trash-put";
      hw = "hwinfo --short";
      changemac = "macchanger -r";
      resetmac = "macchanger -p";
    };
    extraConfig = ''
      $env.config = {
        show_banner: false

        ls: {
          use_ls_colors: true
          clickable_links: true
        }

        table: {
          mode: rounded
          index_mode: always
          show_empty: true
          padding: { left: 1, right: 1}
          trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
            truncating_suffix: "..."
          }
          header_on_separator: false
        }

        error_style: fancy

        completions: {
          case_sensitive: false # case-sensitive completions.
          quick: false    # set to false to prevent auto-selecting completions.
          partial: true    # set to false to prevent partial filling of the prompt.
          algorithm: "prefix"    # prefix or fuzzy.
          sort: "smart"
          external: {
            enable: true
            max_results: 100
            completer: null
          }
          use_ls_colors: true
        }
        edit_mode: vi
        
        cursor_shape: {
          vi_insert: block
          vi_normal: underscore
        }
      }
    '';
    envFile.text = ''
      zoxide init nushell | save -f ~/.zoxide.nu
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
        source ~/.zoxide.nu
        start_zellij
        nerdfetch
      '';
    };
  };

}
