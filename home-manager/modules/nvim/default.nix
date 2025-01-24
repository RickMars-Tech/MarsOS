{ pkgs, ... }: {

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    package = pkgs.neovim-unwrapped;
    plugins = with pkgs.vimPlugins; [
      avante-nvim
      twilight-nvim
      iceberg-vim
      nvim-fzf
      nvim-lspconfig
      nvim-cmp
      nvim-tree-lua
      indent-blankline-nvim
      nvim-treesitter-textobjects
      vim-airline
      lspkind-nvim
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp-cmdline
      nerdcommenter
      rainbow
      vim-nix
    ];

    extraPython3Packages = pyPkgs: with pyPkgs; [
      pytest
      pylint
    ];

    extraLuaConfig = ''
      -- General Settings
      vim.o.syntax = 'on'
      vim.o.termguicolors = true
      vim.o.fileencoding = 'utf-8'
      vim.o.mouse = 'a'
      vim.o.number = true
      vim.o.relativenumber = false
      vim.o.clipboard = 'unnamedplus'
      vim.o.expandtab = false
      vim.o.smartindent = true
      vim.o.shiftwidth = 4
      vim.o.softtabstop = 4
      vim.o.tabstop = 4
      vim.o.hidden = true
      vim.o.wrap = false
      vim.o.termguicolors = true
      vim.o.smartcase = true
      vim.o.ignorecase = true
      vim.o.completeopt = 'menuone,noinsert,noselect'

      vim.api.nvim_create_autocmd({'BufWinEnter'}, {
        desc = 'return cursor to where it was last time closing the file',
        pattern = '*',
        command = 'silent! normal! g`"zv',
      })

      -- Indent Blankline & Rainbow Indentation
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
          vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
          vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
          vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
          vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
          vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
          vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      require("ibl").setup { indent = { highlight = highlight } }

      -- Colorscheme
      vim.cmd.colorscheme "iceberg"

      -- LSP Config
      local lspconfig = require('lspconfig')
      local cmp = require'cmp'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Enable LSP for languages
      lspconfig.pyright.setup{ capabilities = capabilities }
      lspconfig.rust_analyzer.setup{ capabilities = capabilities }
      lspconfig.nixd.setup{ capabilities = capabilities }

      -- Autocompletion with nvim-cmp
      cmp.setup({
        snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
          mapping = {
            ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
            ['<C-e>'] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          },
          sources = {
            { name = 'nvim_lsp' },
            { name = 'buffer' },
            { name = 'path' },
            { name = 'cmdline' },
          }
      })

      -- File Explorer (nvim-tree)
      require'nvim-tree'.setup({
        disable_netrw = true,
        hijack_netrw = true,
        open_on_tab = false,
        hijack_cursor = true,
        update_cwd = true,
        update_focused_file = {
          enable = true,
          update_cwd = false,
        }
      })

      -- Airline Status Bar
      vim.g.airline_theme = 'dark'
      vim.g.airline_powerline_fonts = 1
      vim.g.airline_left_sep = ''
      vim.g.airline_right_sep = ''

      -- Nvim Tree Sidebar (on the right)
      vim.g.nvim_tree_side = 'right'

      -- Enable filetype detection
      vim.cmd('filetype plugin indent on')

      -- Keymaps
      -- Twilight -- Ctrl+h
      vim.api.nvim_set_keymap("n", "<C-h>", "<cmd>Twilight<CR>", { noremap = true, silent = true })

      -- NvimTree -- Ctrl+j
      vim.api.nvim_set_keymap("n", "<C-j>", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })

    '';
  };
}
