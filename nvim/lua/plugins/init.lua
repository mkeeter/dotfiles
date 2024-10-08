return {
  -- Add support for Fish and Rhai scripting
  'dag/vim-fish',
  'rhaiscript/vim-rhai',

  {
    'ggandor/leap.nvim',
    config = function()
      local bufopts = { silent=true }
      vim.keymap.set('n', '<Space>', '<Plug>(leap-forward)', bufopts)
      vim.keymap.set('n', '<C-Space>', '<Plug>(leap-backward)', bufopts)
    end
  },

  -- nvim-tree
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>d', ':NvimTreeOpen<cr>', {noremap = true})
      require'nvim-tree'.setup{
        filters = {
          dotfiles = true,
        },
        hijack_cursor = true,
        update_cwd = true,
      }
    end
  },

  -- vim-tmux-navigator
  'christoomey/vim-tmux-navigator',

  -- Universal search
  {
    'nvim-telescope/telescope.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      local bufopts = { noremap=true, silent=true }
      vim.api.nvim_set_keymap('n', '<Leader>t', ':Telescope find_files<cr>', bufopts)
      vim.api.nvim_set_keymap('n', '<Leader>a', ':Telescope live_grep<cr>', bufopts)
      vim.api.nvim_set_keymap('n', '<Leader>b', ':Telescope buffers<cr>', bufopts)
      vim.api.nvim_set_keymap('n', '<Leader>h', ':Telescope help_tags<cr>', bufopts)
      local actions = require "telescope.actions";
      require('telescope').setup{
        defaults = {
          -- Default configuration for telescope goes here:
          -- config_key = value,
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous
            }
          }
        }
      }
    end
  },

  -- Solarized
  {
    'ishan9299/nvim-solarized-lua',
    priority = 1000, -- load this first!
    config = function()
      vim.opt.termguicolors = true
      vim.o.bg = 'dark'
      vim.cmd([[colorscheme solarized]])
    end
  },

  -- lualine
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      -- Hide mode, since it's visible in lualine
      vim.o.showmode = false
      -- Tweak the default configuration to put the diff stats into section
      -- c instead of b (which has the correct background color)
      require'lualine'.setup {
          options = {
            theme = 'solarized_dark',
          },
          extensions = {'nvim-tree'},
          sections = {
            lualine_b = {'branch'},
            lualine_c = {'diff', 'filename', {'diagnostics', sources={'nvim_diagnostic'}}},
            lualine_x = {'encoding', 'filetype'},
          }
      }
    end
  },

  -- Rust stuff
  {
    'neovim/nvim-lspconfig',
    config = function()
      local bufopts = { noremap=true, silent=true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = false,
        float = { border = "single" },
      })

      require'lspconfig'.rust_analyzer.setup{
        settings = {
          ['rust-analyzer'] = {
            -- enable clippy on save
            checkOnSave = {
              command = "clippy",
              extraArgs = { '--target-dir', 'target/rust-analyzer' },
            },
            procMacro = { enable = true },
            diagnostics = {
              disabled = {"inactive-code"},
            },
          }
        }
      }

      -- Disable LSP highlighting in comments, where it does a bad job
      vim.api.nvim_set_hl(0, '@lsp.type.comment.rust', {})

      -- Run rustfmt on change
      vim.api.nvim_create_autocmd({"BufWritePre"}, {
        pattern = {"*.rs"},
        callback = function() vim.lsp.buf.format({timeout_ms = 200}) end
      })

      -- Customize signs
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      vim.diagnostic.config({
          -- Insert floaty things to the right of problems.
          virtual_text = true,
          -- Display icony things in the sign column.
          signs = true,
          -- Change from neovim's default sort mode for signs, which tends
          -- to hide errors, to the one that should obviously be the
          -- default, which shows most severe in preference to least.
          severity_sort = true,
          -- Underline problems.
          underline = true,
      })

      -- XXX Hack the hover window to show the markdown code fences
      local prev = vim.lsp.util.open_floating_preview
      vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
        local prev_win = vim.api.nvim_get_current_win()
        prev(contents, syntax, opts)
        local bufnr, winnr = prev(contents, syntax, opts)
        vim.wo[winnr].conceallevel = 0
        vim.api.nvim_set_current_win(prev_win)
        return bufnr, winnr
      end
    end
  },

  -- Autocomplete
  {
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path' },
    config = function()
      -- Set completeopt to have a better completion experience
      -- :help completeopt
      -- menuone: popup even when there's only one match
      -- noinsert: Do not insert text until a selection is made
      -- noselect: Do not select, force user to select one from the menu
      vim.o.completeopt = "menuone,noinsert,noselect"

      -- Avoid showing extra messages when using completion
      vim.o.shortmess = vim.o.shortmess .. "c"
      local cmp = require'cmp'
      cmp.setup{
        sources = {
          { name = 'nvim_lsp' },
          { name = 'path' },
        },
        mapping = {
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        }
      }
    end
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require'nvim-treesitter.install'.prefer_git = true
      require'nvim-treesitter.configs'.setup({
        ensure_installed = {
            "rust",
            "c",
            "markdown_inline", -- for `K` / `vim.lsp.buffer.hover()`
        },
      })
    end
  },

  -- Progress spinner for Rust LSP
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require'fidget'.setup{}
    end
  },

  -- Personal wiki
  {
    'vimwiki/vimwiki',
    init = function()
      -- Tweak conceallevel for consistent line spacing
      vim.api.nvim_set_var('vimwiki_conceallevel', 1);
    end,
    config = function()
      vim.api.nvim_set_var('vimwiki_list', {
        {
          path = '~/wiki',
          syntax = 'markdown',
          ext = '.md',
        }
      })
      vim.cmd[[
        hi link VimwikiHeader1 pandocBlockQuoteLeader4
        hi link VimwikiHeader2 pandocBlockQuoteLeader3
        hi link VimwikiHeader3 pandocBlockQuoteLeader2
        hi link VimwikiHeader4 pandocBlockQuoteLeader1
        hi link VimwikiHeader5 pandocBlockQuoteLeader5
        hi link VimwikiHeader6 pandocBlockQuoteLeader6
        map <leader>w<leader>d :VimwikiDiaryPrevDay<CR>
        map <leader>w<leader>f :VimwikiDiaryNextDay<CR>
      ]]
    end
  },
}
