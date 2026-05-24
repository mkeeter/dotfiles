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

-- Enable project-specific `.nvim.lua` files
vim.o.exrc = true

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

-- WELCOME TO THE PLUGIN ZONE --

--------------------------------------------------------------------------------
-- vim-fish
vim.pack.add{ 'https://github.com/dag/vim-fish' }

--------------------------------------------------------------------------------
-- vim-rhai
vim.pack.add{ 'https://github.com/rhaiscript/vim-rhai' }

--------------------------------------------------------------------------------
-- leap.nvim
vim.pack.add{ 'https://codeberg.org/andyg/leap.nvim.git' }
local bufopts = { silent=true }
vim.keymap.set('n', '<Space>', '<Plug>(leap-forward)', bufopts)
vim.keymap.set('n', '<C-Space>', '<Plug>(leap-backward)', bufopts)

--------------------------------------------------------------------------------
-- neo-tree.nvim
vim.pack.add{
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}
require("neo-tree").setup{
  close_if_last_window = true,
  enable_git_status = false,
  enable_modified_markers = false,
}
local bufopts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<Leader>d', ':Neotree<cr>', bufopts);

--------------------------------------------------------------------------------
-- vim-tmux-navigator
vim.pack.add{ 'https://github.com/christoomey/vim-tmux-navigator' }

--------------------------------------------------------------------------------
-- telescope.nvim
vim.pack.add{
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
}
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

--------------------------------------------------------------------------------
-- nvim-solarized-lua
vim.pack.add{ 'https://github.com/ishan9299/nvim-solarized-lua' }
vim.opt.termguicolors = true
vim.o.bg = 'dark'
vim.cmd([[colorscheme solarized]])

--------------------------------------------------------------------------------
-- lualine.nvim
vim.pack.add{ 'https://github.com/nvim-lualine/lualine.nvim' }
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

--------------------------------------------------------------------------------
-- nvim-lspconfig (and the rust-analyzer zone)
vim.pack.add{ 'https://github.com/neovim/nvim-lspconfig' }
local bufopts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.diagnostic.config{
  virtual_text = false,
  signs = true,
  underline = false,
  float = { border = "single" },
}

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      -- enable clippy on save
      checkOnSave = true,
      check = {
        command = "clippy",
      },
      procMacro = { enable = true },
      diagnostics = {
        disabled = {"inactive-code"},
      },
      cargo = {
        targetDir = "target/rust-analyzer",
      },
    }
  }
})
vim.lsp.enable('rust_analyzer')

-- Disable LSP highlighting in comments, where it does a bad job
vim.api.nvim_set_hl(0, '@lsp.type.comment.rust', {})

-- Run rustfmt on change
vim.api.nvim_create_autocmd({"BufWritePre"}, {
  pattern = {"*.rs"},
  callback = function() vim.lsp.buf.format{timeout_ms = 200} end
})

vim.diagnostic.config{
    -- Insert floaty things to the right of problems.
    virtual_text = true,
    -- Display icony things in the sign column.
    signs = {
      text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰌶",
          [vim.diagnostic.severity.HINT] = " ",
      },
    },
    -- Change from neovim's default sort mode for signs, which tends
    -- to hide errors, to the one that should obviously be the
    -- default, which shows most severe in preference to least.
    severity_sort = true,
    -- Underline problems.
    underline = true,
}

-- Helper function to switch to WASM mode
local function set_rust_wasm_mode(enable)
  local clients = vim.lsp.get_active_clients{ name = 'rust_analyzer' }
  if enable then
    flags = {
      target = "wasm32-unknown-unknown",
      extraEnv = {
        RUSTFLAGS = '-C target-feature=+atomics,+bulk-memory --cfg getrandom_backend="wasm_js"',
        RUSTUP_TOOLCHAIN = "nightly-2025-06-30",
      },
      extraArgs = { "-Z", "build-std=std,panic_abort" },
    }
  else
    flags = {
      target = nil,
      extraEnv = nil,
      extraArgs = nil,
    }
  end

  for _, client in ipairs(clients) do
    client.config.settings['rust-analyzer'] = vim.tbl_deep_extend('force',
      client.config.settings['rust-analyzer'] or {},
      {
        cargo = flags,
        check = flags,
      }
    )
    client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
  end

  print(enable and 'Rust WASM mode enabled' or 'Rust WASM mode disabled')
end

-- Create commands
vim.api.nvim_create_user_command('RustWasmMode', function()
  set_rust_wasm_mode(true)
end, {})

vim.api.nvim_create_user_command('RustNormalMode', function()
  set_rust_wasm_mode(false)
end, {})

--------------------------------------------------------------------------------
-- nvim-cmp
vim.pack.add{
  'https://github.com/hrsh7th/nvim-cmp',
  'https://github.com/hrsh7th/cmp-nvim-lsp',
  'https://github.com/hrsh7th/cmp-path',
}
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
    ["<CR>"] = cmp.mapping.confirm{
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
  }
}

--------------------------------------------------------------------------------
-- nvim-treesitter
vim.pack.add{ 'https://github.com/nvim-treesitter/nvim-treesitter' }
require'nvim-treesitter.install'.prefer_git = true
local ts_languages = {
  "rust",
  "c",
  "markdown_inline", -- for `K` / `vim.lsp.buffer.hover()`
  "just",
  "lua",
  "wgsl",
}
require'nvim-treesitter'.install(ts_languages)
vim.api.nvim_create_autocmd(
  'PackChanged',
  { callback = function()
      if name == 'nvim-treesitter' and kind == 'update' then
        require('nvim-treesitter').update()
      end
    end
  }
)
vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_languages,
  callback = function() vim.treesitter.start() end,
})

--------------------------------------------------------------------------------
-- fidget.nvim
vim.pack.add{ 'https://github.com/j-hui/fidget.nvim' }
require'fidget'.setup{}

--------------------------------------------------------------------------------
-- vimwiki
vim.pack.add{ 'https://github.com/vimwiki/vimwiki' }
vim.api.nvim_set_var('vimwiki_conceallevel', 1)
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
