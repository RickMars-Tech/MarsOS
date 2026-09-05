{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.yazi =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myYazi
      ];
    };
  perSystem =
    { pkgs, ... }:
    {
      packages.myYazi = inputs.wrapper-modules.wrappers.yazi.wrap {
        inherit pkgs;

        settings = {
          yazi = {
            preview = {
              tab_size = 2;
              max_width = 600;
              max_height = 900;
            };
            opener = {
              edit = [
                {
                  run = "$EDITOR %s";
                  block = true;
                }
              ];
              open = [
                {
                  run = "xdg-open %s1";
                  desc = "Open";
                }
              ];
              play = [
                {
                  run = "mpv %s";
                  orphan = true;
                }
              ];
              view = [
                {
                  run = "swayimg %s";
                  block = true;
                }
              ];
            };
            open = {
              rules = [
                {
                  url = "*/";
                  use = [
                    "edit"
                    "open"
                  ];
                }
                {
                  url = "*.json";
                  use = [
                    "edit"
                    "open"
                  ];
                }
                {
                  mime = "image/*";
                  use = [
                    "view"
                  ];
                }
                {
                  mime = "video/*";
                  use = [
                    "play"
                  ];
                }
                {
                  mime = "audio/*";
                  use = [
                    "play"
                    "open"
                  ];
                }
                {
                  mime = "text/*";
                  use = [
                    "edit"
                    "open"
                  ];
                }
                {
                  mime = "inode/x-empty";
                  use = [
                    "edit"
                    "open"
                  ];
                }
                {
                  mime = "application/json";
                  use = [
                    "edit"
                    "open"
                  ];
                }
                {
                  url = "CONTENTS";
                  use = [
                    "edit"
                    "open"
                  ];
                }
                {
                  url = "*";
                  use = [
                    "edit"
                    "open"
                  ];
                }
              ];
            };
            plugin = { };
          };
          keymap = {
            mgr = {
              prepend_keymap = [
                {
                  on = "F";
                  run = "plugin smart-filter";
                  desc = "Smart filter";
                }
                {
                  on = "p";
                  run = "plugin smart-paste";
                  desc = "Paste into the hovered directory or CWD";
                }
                {
                  on = "l";
                  run = "plugin smart-enter";
                  desc = "Enter the child directory, or open the file";
                }
              ];
            };
          };
          theme = {
            mgr = {
              layout = [
                1
                4
                3
              ];
              sort_by = "alphabetical";
              sort_sensitive = true;
              sort_reverse = false;
              sort_dir_first = true;
              linemode = "none";
              show_hidden = false;
              show_symlink = true;
            };
          };
        };
        plugins = with pkgs.yaziPlugins; {
          inherit smart-enter;
          inherit smart-paste;
          inherit smart-filter;
        };
      };
    };
}
