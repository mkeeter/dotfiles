vim.o.number = true
vim.o.mouse = 'a'
vim.o.colorcolumn = '80'

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
vim.o.linebreak = true

-- Show trailing whitespace
vim.o.list = true
vim.o.listchars="tab:»·,trail:·"

-- Use , as the leader key
vim.g.mapleader = ","

-- Set current directory
vim.cmd[[cd %:p:h]]

-- Load all of our plugins
require('plugins')

require('rust-config')
