return require('packer').startup{function()
  -- Packer can manage itself
  use {
    'wbthomason/packer.nvim',
    config = function()
      -- Recompile whenever plugins.lua changes
      vim.cmd([[
        augroup packer_user_config
          autocmd!
          autocmd BufWritePost plugins.lua source <afile> | PackerCompile
        augroup end
      ]])
    end
  }
  use 'dag/vim-fish'
  use 'lewis6991/impatient.nvim'

  -- nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
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
  }

  -- vim-tmux-navigator
  use 'christoomey/vim-tmux-navigator'

  -- Universal search
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>t', ':Telescope find_files<cr>', {noremap = true})
      vim.api.nvim_set_keymap('n', '<Leader>a', ':Telescope live_grep<cr>', {noremap = true})
      vim.api.nvim_set_keymap('n', '<Leader>b', ':Telescope buffers<cr>', {noremap = true})
      vim.api.nvim_set_keymap('n', '<Leader>h', ':Telescope help_tags<cr>', {noremap = true})
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
  }

  -- Solarized
  use {
    'ishan9299/nvim-solarized-lua',
    config = function()
      vim.opt.termguicolors = true
      vim.o.bg = 'dark'
      vim.cmd([[colorscheme solarized]])
    end
  }

  -- lualine
  use {
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
  }

  -- Rust stuff
  -- https://sharksforarms.dev/posts/neovim-rust/
  use {
    'neovim/nvim-lspconfig',
    config = function()
      vim.o.updatetime = 750 -- triggers CursorHold more often
      vim.api.nvim_create_autocmd({"CursorHold"}, {callback = function()
        vim.diagnostic.open_float({focus = false})
      end})
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = false,
        float = { border = "single" },
      })
    end
  }
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      -- Set completeopt to have a better completion experience
      -- :help completeopt
      -- menuone: popup even when there's only one match
      -- noinsert: Do not insert text until a selection is made
      -- noselect: Do not select, force user to select one from the menu
      vim.o.completeopt = "menuone,noinsert,noselect"

      -- Avoid showing extra messages when using completion
      vim.o.shortmess = vim.o.shortmess .. "c"

      -- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
      local cmp = require'cmp'
      cmp.setup{
        -- Enable LSP snippets
        snippet = {
          expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Add tab support
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm{
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }
        },

        -- Installed sources
        sources = {
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'buffer' },
        },

        enabled = function()
          local ctx = require"cmp.config.context"
          if ctx.in_syntax_group("Comment") or
             ctx.in_treesitter_capture("comment") or
             ctx.in_syntax_group("SpecialComment")
          then
            return false
          else
            return true
          end
        end
      }

      -- Disable autocomplete for VimWiki buffers
      vim.api.nvim_create_autocmd({"FileType"}, {
          pattern = {"VimWiki", "asciidoc"},
          callback = function()
            require'cmp'.setup.buffer { enabled = false }
          end
      })
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use {
    'hrsh7th/cmp-nvim-lsp',
    ft = "rust",
  }
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use {
    'simrat39/rust-tools.nvim',
    ft = "rust",
    config = function()
      vim.o.signcolumn = 'yes'
      vim.api.nvim_create_autocmd({"BufWritePre"}, {
        pattern = {"*.rs"},
        callback = function() vim.lsp.buf.formatting_sync(nil, 200) end
      })

      -- Configure LSP through rust-tools.nvim plugin.
      -- rust-tools will configure and enable certain LSP features for us.
      -- See https://github.com/simrat39/rust-tools.nvim#configuration
      require'rust-tools'.setup{
        tools = { -- rust-tools options
          autoSetHints = true,
          hover_with_actions = true,
          inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
          },
        },

        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
        server = {
          -- on_attach is a callback called when the language server attachs to the buffer
          -- on_attach = on_attach,
          settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
              -- enable clippy on save
              checkOnSave = {
                command = "clippy",
                extraArgs = { '--target-dir', 'target/rust-analyzer' },
              },
              diagnostics = {
                disabled = {"inactive-code"}
              },
            }
          }
        },
      }
    end
  }
  use {
    'tami5/lspsaga.nvim',
    ft = "rust",
    config = function()
      require'lspsaga'.init_lsp_saga{
        code_action_prompt = {
          enable = false
        }
      }
    end
  }

  -- Personal wiki
  use {
    'vimwiki/vimwiki',
    config = function()
      vim.api.nvim_set_var('vimwiki_list', {
          {path = '~/wiki',
           syntax = 'markdown',
           ext = '.md' }})
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
  }
  end,
  config = {
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = vim.fn.stdpath('config')..'/lua/packer_compiled.lua'
  }
}
