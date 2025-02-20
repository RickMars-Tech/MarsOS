{
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.stylix.base16Scheme;
in {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;
    settings.vim = {
      mini = {
        icons.enable = true;
        statusline.enable = true;
        notify.enable = true;
        indentscope.enable = true;
      };
      theme = {
          enable = true;
          name = "base16";
          base16-colors = {
            base00 = cfg.base00;
            base01 = cfg.base01;
            base02 = cfg.base02;
            base03 = cfg.base03;
            base04 = cfg.base04;
            base05 = cfg.base05;
            base06 = cfg.base06;
            base07 = cfg.base07;
            base08 = cfg.base08;
            base09 = cfg.base09;
            base0A = cfg.base0A;
            base0B = cfg.base0B;
            base0C = cfg.base0C;
            base0D = cfg.base0D;
            base0E = cfg.base0E;
            base0F = cfg.base0F;
          };
        };
      useSystemClipboard = true;
      options = {
        #==> Space Idents
        shiftwidth = 2;
        softtabstop = 2;
        tabstop = 2;
        expandtab = true;
        autoindent = true;
        smartindent = true;
        breakindent = true;

        #==> Misc
        termguicolors = true;
        cursorline = true;
        mouse = "a";
        wrap = false;
      };
      statusline.lualine.enable = true;
      telescope.enable = false;
      autocomplete.nvim-cmp.enable = true;
      visuals = {
        nvim-web-devicons.enable = true;
        rainbow-delimiters.enable = true;
      };
      lsp = {
        formatOnSave = true;
        trouble.enable = true;
      };
      languages = {
        enableExtraDiagnostics = true;
        enableTreesitter = true;
        nix = {
          enable = true;
          extraDiagnostics = {
            enable = true;
            types = [
              "statix"
              "deadnix"
            ];
          };
          lsp = {
            enable = true;
            package = pkgs.nil;
            server = "nil";
          };
          format = {
            enable = true;
            package = pkgs.alejandra;
            type = "alejandra";
          };
          treesitter.enable = true;
        };
        rust = {
          enable = true;
          lsp.enable = true;
          treesitter.enable = true;
          format = {
            enable = true;
            package = pkgs.rustfmt;
            type = "rustfmt";
          };
        };
        clang = {
          enable = true;
          lsp.enable = true;
        };
        sql = {
          enable = true;
          lsp.enable = true;
        };
        python = {
          enable = true;
          dap.enable = true;
          lsp = {
            enable = true;
            package = pkgs.pyright;
            server = "pyright";
          };
          format = {
            enable = true;
            package = pkgs.black;
            type = "black";
          };
          treesitter.enable = true;
        };
        zig = {
          enable = true;
          lsp.enable = true;
        };
      };
    };
  };
}
