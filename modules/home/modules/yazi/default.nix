{
  config,
  pkgs,
  ...
}: let
  color = config.stylix.base16Scheme;
in {
  imports = [
    ./theme/icons.nix
    # ./theme/manager.nix
    # ./theme/status.nix
  ];
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    enableFishIntegration = true;
    # package = inputs.yazi.packages.${pkgs.system}.default;
    settings.yazi = {
      manager = {
        sort_by = "natural";
        show_hidden = true;
        show_symlink = true;
      };
      preview = {
        tab_size = 2;
        image_filter = "triangle"; #"lanczos3";
        image_delay = 10;
        image_quality = 70;
        max_width = 600;
        max_height = 900;
        ueberzug_scale = 1;
        ueberzug_offset = [
          0
          0
          0
          0
        ];
        cache_dir = "${config.xdg.cacheHome}";
      };
      tasks = {
        micro_workers = 5;
        macro_workers = 10;
        bizarre_retry = 5;
      };
      theme = {
        filetype = {
          rules = [
            {
              fg = color.base09;
              mime = "image/*";
            }
            {
              fg = color.base0C;
              mime = "video/*";
            }
            {
              fg = color.base0A;
              mime = "audio/*";
            }
            {
              fg = color.base0B;
              mime = "application/bzip";
            }
          ];
        };
      };
    };
  };
}
