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
      vim.api.nvim_set_var('nvim_tree_hide_dotfiles', 1)
      require'nvim-tree'.setup {
        hijack_cursor = true,
        update_cwd = true,
        auto_close = true,
      }
    end
  }

  -- vim-tmux-navigator
  use 'christoomey/vim-tmux-navigator'

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
      vim.o.showmode = false
      require'lualine'.setup {
          options = { theme = 'solarized_dark' }
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
end)
