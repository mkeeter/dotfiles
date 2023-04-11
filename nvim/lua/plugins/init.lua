return {
  -- Add support for Fish and Rhai scripting
  'dag/vim-fish',
  'rhaiscript/vim-rhai',

  {
    'ggandor/leap.nvim',
    config = function()
      local bufopts = { silent=true }
      vim.keymap.set('n', '<Space>', '<Plug>(leap-forward)', bufopts)
      vim.keymap.set('n', '<Leader><Space>', '<Plug>(leap-backward)', bufopts)
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
  -- https://sharksforarms.dev/posts/neovim-rust/
  {
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
    build = ':TSUpdate'
  },
  {
    'simrat39/rust-tools.nvim',
    ft = "rust",
    config = function()
      vim.o.signcolumn = 'yes'
      vim.api.nvim_create_autocmd({"BufWritePre"}, {
        pattern = {"*.rs"},
        callback = function() vim.lsp.buf.format({timeout_ms = 200}) end
      })

      vim.cmd"let g:rust_recommended_style = 0"

      -- monkeypatch rust-tools to correctly detect our custom rust-analyzer
      require'rust-tools.utils.utils'.is_ra_server = function (client)
        local name = client.name
        local target = "rust_analyzer"
        return string.sub(client.name, 1, string.len(target)) == target
          or client.name == "rust_analyzer-standalone"
      end

      -- Configure LSP through rust-tools.nvim plugin, with lots of bonus
      -- content for Hubris compatibility
      local cache = {}
      local clients = {}
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
              local cmd = dir .. "/target/debug/xtask lsp "
              -- Notify `xtask lsp` of existing clients in the CLI invocation,
              -- so it can check against them first (which would mean a faster
              -- attach)
              for _,v in pairs(clients) do
                local c = vim.fn.escape(vim.json.encode(v), '"')
                cmd = cmd .. '-c"' .. c .. '" '
              end
              local handle = io.popen(cmd .. bufname)
              handle:flush()
              local result = handle:read("*a")
              handle:close()
              vim.cmd("cd " .. prev_cwd)

              -- If `xtask` doesn't know about `lsp`, then it will print an
              -- error to stderr and return nothing on stdout.
              if result == "" then
                vim.notify("recompile `xtask` for `lsp` support",
                           vim.log.levels.WARN)
              end

              -- If the given file can be compiled as part of a Hubris task,
              -- then we give the rust-analyzer client a custom name (to prevent
              -- multiple buffers from attaching to it), then cache the JSON in
              -- a local variable for use in `on_attach`
              local json = vim.json.decode(result)
              if json["Ok"] ~= nil then
                new_config.name = "rust_analyzer_" .. json.Ok.hash
                cache[bufnr] = json
                -- Record the existence of this client, to encourage reuse
                table.insert(clients, {toml = json.Ok.app, task = json.Ok.task})
              else
                vim.notify(vim.inspect(json.Err), vim.log.levels.ERROR)
              end
            end
          end,

          on_attach = function(client, bufnr)
            local json = cache[bufnr]
            if json ~= nil then
              local config = vim.deepcopy(client.config)
              local ra = config.settings["rust-analyzer"]
              -- Do rust-analyzer builds in a separate folder to avoid blocking
              -- the main build with a file lock.
              table.insert(json.Ok.buildOverrideCommand, "--target-dir")
              table.insert(json.Ok.buildOverrideCommand, "target/rust-analyzer")
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
              config.lspinfo = function()
                return { "Hubris app:      " .. json.Ok.app,
                         "Hubris task:     " .. json.Ok.task }
              end
              client.config = config
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
              procMacro = { enable = true },
              diagnostics = {
                disabled = {"inactive-code"},
              },
            }
          }
        },
      }
    end
  },

  {
    'tami5/lspsaga.nvim',
    ft = "rust",
    config = function()
      require'lspsaga'.init_lsp_saga{
        code_action_prompt = {
          enable = false
        }
      }
    end
  },

  -- Progress spinner for Rust LSP
  {
    'j-hui/fidget.nvim',
    config = function()
      require'fidget'.setup{}
    end
  },

  -- Personal wiki
  {
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
  },
}
