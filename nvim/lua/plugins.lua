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
      }
    end
  }

  -- vim-tmux-navigator
  use 'christoomey/vim-tmux-navigator'

  -- fzf
  use {
    'junegunn/fzf.vim',
    requires = 'junegunn/fzf',
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>t', ':Files <cr>', {})
      vim.api.nvim_set_keymap('n', '<Leader>b', ':Buffers <cr>', {})
    end
  }

  -- vim-grepper
  use {
    'mhinz/vim-grepper',
    config = function()
      vim.api.nvim_set_keymap('n', '<Leader>a', ':GrepperRg ', {})
      vim.api.nvim_set_var('grepper', { tools = {'rg'}})
      vim.cmd([[
        autocmd BufWinEnter quickfix nnoremap <silent> <buffer> q :cclose<cr>:lclose<cr>
      ]])
    end
  }

  -- Solarized
  use {
    'overcache/NeoSolarized',
    config = function()
      vim.cmd([[colorscheme NeoSolarized]])
    end
  }

  -- lualine
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require'lualine'.setup {
          options = { theme = 'solarized_dark' }
      }
    end
  }
end)
