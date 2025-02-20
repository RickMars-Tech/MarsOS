{ pkgs, ... }:
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    package = pkgs.neovim-unwrapped;

    plugins = with pkgs.vimPlugins; [
      # Dependencias principales
      plenary-nvim
      nui-nvim
      dressing-nvim
      mini-nvim

      # Plugins principales
      avante-nvim
      twilight-nvim
      render-markdown-nvim
      nvim-fzf
      nvim-lspconfig
      nvim-cmp
      nvim-tree-lua
      nvim-treesitter
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
      telescope-nvim
      gitsigns-nvim
      vim-fugitive
      nvim-dap
      nvim-dap-ui
    ];

    extraPackages = with pkgs; [
      fd
      pyright
      #tree-sitter
      nodejs
      nixd
      nixfmt-rfc-style
      nodePackages.typescript-language-server
      nodePackages.eslint
      ripgrep
    ];

    extraPython3Packages =
      pyPkgs: with pyPkgs; [
        pytest
        pylint
      ];

    extraLuaConfig = ''
      -- Configurar paths escribibles para NixOS
      vim.opt.runtimepath:append("~/.cache/nvim")
      local parser_install_dir = vim.fn.expand("~/.cache/nvim/treesitter")

      -- General Settings
      vim.o.syntax = 'on'
      vim.o.termguicolors = true
      vim.o.fileencoding = 'utf-8'
      vim.o.mouse = 'a'
      vim.o.number = true
      vim.o.relativenumber = true
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
      vim.opt.laststatus = 3

      vim.api.nvim_create_autocmd({'BufWinEnter'}, {
        desc = 'return cursor to where it was last time closing the file',
        pattern = '*',
        command = 'silent! normal! g`"zv',
      })

      -- Definir grupos de colores
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })

      -- Indent Blankline (configuración corregida)
      require("ibl").setup({
        indent = {
          char = "▏",
          highlight = {
            "RainbowRed",
            "RainbowYellow",
            "RainbowBlue",
            "RainbowOrange",
            "RainbowGreen",
            "RainbowViolet",
            "RainbowCyan"
          }
        },
        scope = {
          show_start = false,
          show_end = false
        }
      })

      -- LSP Config
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true})
      end

      local servers = {'pyright', 'rust_analyzer', 'nixd', 'ts_ls', 'eslint'}
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          capabilities = capabilities,
          flags = { debounce_text_changes = 150 }
        }
      end

      -- Autocompletado (nvim-cmp)
      local cmp = require('cmp')
      cmp.setup({
        snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'path' }
        })
      })

      -- Formateo automático al guardar
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*',
        callback = function()
          vim.lsp.buf.format()
        end,
      })

      -- Nvim-Tree
      require('nvim-tree').setup({
        hijack_netrw = true,
        view = { side = "right" },
        renderer = {
          icons = {
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                arrow_closed = "",
                arrow_open = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
              },
            }
          }
        }
      })

      -- Telescope
      require('telescope').setup{
        defaults = { file_ignore_patterns = { "node_modules", ".git" } },
        pickers = { find_files = { hidden = true } }
      }

      -- Mini.icons
      require('mini.icons').setup()

      -- Avante
      require('avante').setup({
        icons = {
          enable = true,
          provider = 'mini',
          custom = {},
        },
        integrations = {
          nvim_tree = true,
          telescope = true,
          lsp = true
        }
      })

      -- Atajos de teclado
      vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
      -- NvimTree -- Ctrl+h
      vim.api.nvim_set_keymap("n", "<C-h>", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
      -- Twilight -- Ctrl+t
      vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>Twilight<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })
    '';
  };
}
