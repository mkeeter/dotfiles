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

  -- Add support for Fish and Rhai scripting
  use 'dag/vim-fish'
  use 'rhaiscript/vim-rhai'

  use {
    'ggandor/leap.nvim',
    config = function()
      vim.keymap.set('n', '<Space>', '<Plug>(leap-forward)', {silent = true})
      vim.keymap.set('n', '<Leader><Space>', '<Plug>(leap-backward)', {silent = true})
    end
  }

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
      local bufopts = { noremap=true, silent=true }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
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
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use {
    'simrat39/rust-tools.nvim',
    ft = "rust",
    config = function()
      vim.o.signcolumn = 'yes'
      vim.api.nvim_create_autocmd({"BufWritePre"}, {
        pattern = {"*.rs"},
        callback = function() vim.lsp.buf.format({timeout_ms = 200}) end
      })

      vim.cmd"let g:rust_recommended_style = 0"

      local cache = {}

      -- Configure LSP through rust-tools.nvim plugin.
      -- rust-tools will configure and enable certain LSP features for us.
      -- See https://github.com/simrat39/rust-tools.nvim#configuration
      require'rust-tools'.setup{
        tools = { -- rust-tools options
          autoSetHints = true,
          inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
          },
        },

        server = {
          on_new_config = function(new_config, new_root_dir)
            local bufnr = vim.api.nvim_get_current_buf()
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local dir = new_config.root_dir()
            if string.find(dir, "hubris") then
              -- Run `xtask lsp` for the target file, which gives us a JSON
              -- dictionary with bonus configuration.
              local prev_cwd = vim.fn.getcwd()
              vim.cmd("cd " .. dir)
              local handle = io.popen(dir .. "/target/debug/xtask lsp " .. bufname)
              handle:flush()
              local result = handle:read("*a")
              handle:close()
              vim.cmd("cd " .. prev_cwd)

              -- If the given file should be handled with special care, then
              -- we give the rust-analyzer client a custom name (to prevent
              -- multiple buffers from attaching to it), then cache the JSON in
              -- a local variable for use in `on_attach`
              local json = vim.json.decode(result)
              if json["Ok"] ~= nil then
                new_config.name = "rust_analyzer_" .. json.Ok.hash
                cache[bufnr] = json
              end
            end
          end,

          on_attach = function(client, bufnr)
            local json = cache[bufnr]
            if json ~= nil then
              local ra = client.config.settings["rust-analyzer"]
              ra.cargo = {
                extraEnv = json.Ok.extraEnv,
                target = json.Ok.target,
                noDefaultFeatures = true,
                features = json.Ok.features,
                buildScripts = {
                  overrideCommand = json.Ok.buildOverrideCommand,
                },
              }
              ra.check = {
                overrideCommand = json.Ok.buildOverrideCommand,
              }
              ra.files = {
                excludeDirs = json.Ok.excludeDirs
              }
            end
          end,

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
                disabled = {"inactive-code"},
              },
            }
          }
        },
      }

      -- monkeypatch rust-tools to correctly detect our custom rust-analyzer
      require'rust-tools'.utils.is_ra_server = function (client)
        local name = client.name
        local target = "rust_analyzer"
        return string.sub(client.name, 1, string.len(target)) == target
          or client.name == "rust_analyzer-standalone"
      end
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
}
