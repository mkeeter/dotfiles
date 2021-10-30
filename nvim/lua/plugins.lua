-- Recompile whenever plugins.lua changes
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- nvim-tree
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>d', ':NvimTreeOpen<cr>', {noremap = true})
      require'nvim-tree'.setup {
        filters = {
          dotfiles = true,
        },
        hijack_cursor = true,
        update_cwd = true,
        auto_close = true,
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
            lualine_c = {'diff', 'filename', {'diagnostics', sources={'nvim_lsp'}}},
            lualine_x = {'encoding', 'filetype'},
          }
      }
    end
  }

  -- Rust stuff
  -- https://sharksforarms.dev/posts/neovim-rust/
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/vim-vsnip'
  use {
    'simrat39/rust-tools.nvim',
    config = function()
      vim.o.signcolumn = 'yes'
    end
  }
  use {
    'glepnir/lspsaga.nvim',
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
      ]]
    end
  }
end)
