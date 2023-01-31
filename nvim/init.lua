vim.o.number = true
vim.o.mouse = 'a'
vim.o.colorcolumn = '80'

-- Formatting and wrapping of comments
vim.o.textwidth = 80
vim.o.formatoptions = 'qjcn'

-- Allow unsaved changes in non-open windows
vim.o.hidden = true

-- Yank to and put from system clipboard
vim.o.clipboard = 'unnamed'

-- Indentation!
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.tabstop = 4

-- Wrapping
vim.wo.wrap = false

-- Show trailing whitespace
vim.o.list = true
vim.o.listchars="tab:»·,trail:·"

vim.o.wildmode = 'longest,list,full'
vim.o.wildmenu = true

-- Use , as the leader key
vim.g.mapleader = ","

-- Set current directory
vim.cmd[[cd %:p:h]]

-- Bind 'q' to close a quickfix window
vim.cmd[[autocmd BufWinEnter quickfix nnoremap <buffer> q :cclose<CR>]]

-- Allow for persistent undo
vim.o.undofile = true

-- Autocompile website whenever making changes
vim.cmd[[autocmd BufWrite ~/Web/* silent exec "!make"]]

-- Plugin cache must be loaded before any other plugins
-- (TODO: remove when https://github.com/neovim/neovim/pull/15436 is merged)
require('packer_compiled')

-- Load all of our plugins
require('plugins')

-- Filetype handlers for Metal shaders
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.metal"},
  callback = function()
    vim.bo.filetype = "metal"
  end
})
