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

-- Use , as the leader key (must happen before plugin init)
vim.g.mapleader = ","

-- Set current directory
vim.cmd[[cd %:p:h]]

-- Bind 'q' to close a quickfix or loclist window
vim.api.nvim_create_autocmd(
  'BufWinEnter',
  {
    pattern = 'quickfix',
    callback = function()
      local t = vim.fn.win_gettype()
      local cmd = ""
      if t == "loclist" then
        cmd = ":lclose<CR>"
      elseif t == "quickfix" then
        cmd = ":cclose<CR>"
      end
      vim.api.nvim_buf_set_keymap(0, 'n', 'q', cmd, { noremap = true })
    end
  }
);


-- Allow for persistent undo
vim.o.undofile = true

-- Autocompile website whenever making changes
vim.cmd[[autocmd BufWrite ~/Web/* silent exec "!make"]]

-- Filetype handlers for Metal shaders
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.metal"},
  callback = function()
    vim.bo.filetype = "metal"
  end
})

--------------------------------------------------------------------------------
---- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

return require('lazy').setup('plugins')
