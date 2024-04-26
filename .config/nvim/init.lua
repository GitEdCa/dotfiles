vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
 
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Enable break indent
vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- Decrease update time
vim.opt.updatetime = 250
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
--vim.opt.list = true
--vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- copy/paste system clipboard
vim.keymap.set('n', '<leader>y', '"+y', {desc = 'copy to system clipboard'})
vim.keymap.set('n', '<leader>p', '"+p', {desc = 'paste from system clipboard'})
vim.keymap.set('n', '<leader>p', '"+P', {desc = 'paste from system clipboard'})
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('n', '<leader>v', '<cmd>:e $MYVIMRC<CR>', { desc = "Open VIMRC"})

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({'BufEnter', 'BufNewFile'}, {
  desc = 'Set syntax asciidoc',
  pattern = "*.txt",
  group = vim.api.nvim_create_augroup('set-asciidoc-syntax', { clear = true }),
  callback = function()
    vim.cmd[[set syntax=asciidoc]]
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-fugitive', -- Detect tabstop and shiftwidth automatically

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
  end,
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
        ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
        ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
      }
    end,
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',

    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Search Files' })
      vim.keymap.set('n', '<leader>,', builtin.builtin, { desc = 'Search Select Telescope' })
      vim.keymap.set('n', '<leader>d', builtin.diagnostics, { desc = 'Search Diagnostics' })
      vim.keymap.set('n', '<leader>z', builtin.resume, { desc = 'Search Resume' })
      vim.keymap.set('n', '<leader>.', builtin.oldfiles, { desc = 'Search Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Find existing buffers' })
      vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = 'Search Help' })

      vim.keymap.set('n', '<leader>g', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      --vim.keymap.set('n', '<leader>s/', function()
      --  builtin.live_grep {
      --    grep_open_files = true,
      --    prompt_title = 'Live Grep in Open Files',
      --  }
      --end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>*', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  { -- You can easily change to a different colorscheme.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      --vim.cmd.colorscheme 'tokyonight-night'
      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  {
    "rose-pine/neovim",
    priority = 1000,
    config = function()
      require('rose-pine').setup({
        styles = {
          italic = false,
        },
      })
      vim.cmd("colorscheme rose-pine")
    end
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
      require('mini.completion').setup()
      require('mini.comment').setup()
      require('mini.files').setup()

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = false,
      highlight = {
        enable = true,
      },
      indent = { enable = true, disable = { 'ruby' } },
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        node_incremental = '<CR>',
        node_decremental = '<S-CR>'
      }
    },
    config = function(_, opts)
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
  
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('gD', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>s', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>r', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>a', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- Opens a popup that displays documentation about the word under your cursor
          --  See `:help K` for why this keymap.
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end, { buffer = event.buf})

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      --local capabilities = vim.lsp.protocol.make_client_capabilities()
      --capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      
      require('mason').setup()
      require("mason-lspconfig").setup()
      require("mason-lspconfig").setup_handlers {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {}
        end,
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            settings = {Lua = {diagnostics = {globals = {'vim'}}}}
          })
        end
      }
      --local servers = {
      --  clangd = {},
      --  lua_ls = {
      --    settings = {
      --      Lua = {
      --        completion = {
      --          callSnippet = 'Replace',
      --        },
      --        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      --        -- diagnostics = { disable = { 'missing-fields' } },
      --      },
      --    },
      --  },
      --}
      --for server, settings in pairs(servers) do
      --  require('lspconfig')[server].setup(settings)
      --end
      require('lspconfig').clangd.setup {}
    end,
  },


--{ -- Autocompletion
--    'hrsh7th/nvim-cmp',
--    event = 'InsertEnter',
--    dependencies = {
--      -- Snippet Engine & its associated nvim-cmp source
--      {
--        'L3MON4D3/LuaSnip',
--        build = (function()
--          -- Build Step is needed for regex support in snippets.
--          -- This step is not supported in many windows environments.
--          -- Remove the below condition to re-enable on windows.
--          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
--            return
--          end
--          return 'make install_jsregexp'
--        end)(),
--        dependencies = {
--          -- `friendly-snippets` contains a variety of premade snippets.
--          --    See the README about individual language/framework/plugin snippets:
--          --    https://github.com/rafamadriz/friendly-snippets
--          -- {
--          --   'rafamadriz/friendly-snippets',
--          --   config = function()
--          --     require('luasnip.loaders.from_vscode').lazy_load()
--          --   end,
--          -- },
--        },
--      },
--      'saadparwaiz1/cmp_luasnip',
--
--      -- Adds other completion capabilities.
--      --  nvim-cmp does not ship with all sources by default. They are split
--      --  into multiple repos for maintenance purposes.
--      'hrsh7th/cmp-nvim-lsp',
--      'hrsh7th/cmp-path',
--      'hrsh7th/cmp-buffer',
--    },
--    config = function()
--      -- See `:help cmp`
--      local cmp = require 'cmp'
--      local luasnip = require 'luasnip'
--      luasnip.config.setup {}
--
--      cmp.setup {
--        snippet = {
--          expand = function(args)
--            luasnip.lsp_expand(args.body)
--          end,
--        },
--        completion = { completeopt = 'menu,menuone,noinsert' },
--
--        -- For an understanding of why these mappings were
--        -- chosen, you will need to read `:help ins-completion`
--        --
--        -- No, but seriously. Please read `:help ins-completion`, it is really good!
--        mapping = cmp.mapping.preset.insert {
--          -- Select the [n]ext item
--          ['<C-n>'] = cmp.mapping.select_next_item(),
--          -- Select the [p]revious item
--          ['<C-p>'] = cmp.mapping.select_prev_item(),
--
--          -- Scroll the documentation window [b]ack / [f]orward
--          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--          ['<C-f>'] = cmp.mapping.scroll_docs(4),
--
--          -- Accept ([y]es) the completion.
--          --  This will auto-import if your LSP supports it.
--          --  This will expand snippets if the LSP sent a snippet.
--          ['<C-y>'] = cmp.mapping.confirm { select = true },
--
--          -- Manually trigger a completion from nvim-cmp.
--          --  Generally you don't need this, because nvim-cmp will display
--          --  completions whenever it has completion options available.
--          ['<C-Space>'] = cmp.mapping.complete {},
--
--          -- Think of <c-l> as moving to the right of your snippet expansion.
--          --  So if you have a snippet that's like:
--          --  function $name($args)
--          --    $body
--          --  end
--          --
--          -- <c-l> will move you to the right of each of the expansion locations.
--          -- <c-h> is similar, except moving you backwards.
--          ['<C-l>'] = cmp.mapping(function()
--            if luasnip.expand_or_locally_jumpable() then
--              luasnip.expand_or_jump()
--            end
--          end, { 'i', 's' }),
--          ['<C-h>'] = cmp.mapping(function()
--            if luasnip.locally_jumpable(-1) then
--              luasnip.jump(-1)
--            end
--          end, { 'i', 's' }),
--
--          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
--          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
--        },
--        sources = {
--          { name = 'nvim_lsp' },
--          { name = 'luasnip' },
--          { name = 'buffer' },
--        },
--      }
--    end,
--  },

  { -- Useful plugin to show you pending keybinds.
    'mbbill/undotree',
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc ="NeoTree" }
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'numToStr/FTerm.nvim',
    keys = {
      { "<leader>t", nil, mode = {"n", "t"}, desc ="FTerm" },
      { "<A-g>", nil, mode = {"n", "t"}, desc ="FTerm" },
    },
    config = function()
      vim.keymap.set('n', '<leader>t', '<CMD>lua require("FTerm").toggle()<CR>')
      vim.keymap.set('t', '<leader>t', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

      local fterm = require("FTerm")
      local gitui = fterm:new({
        ft = 'fterm_gitui', -- You can also override the default filetype, if you want
        cmd = "gitui",
        dimensions = {
          height = 0.9,
          width = 0.9
        }
      })

      -- Use this to toggle gitui in a floating terminal
      vim.keymap.set('n', '<A-g>', function()
        gitui:toggle()
      end)
    end,
  },

  { -- Useful plugin to show you pending keybinds.
    'habamax/vim-asciidoctor',
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
      { "<leader>m", nil, desc ="Add mark to Harpoon" },
      { "<C-h>", nil, desc ="Toggle Harpoon marks window" },
      { "<C-j>", nil, mode = {'n', 't'}, desc ="Got to mark 1" },
      { "<C-k>", nil, mode = {'n', 't'}, desc ="Got to mark 2" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() 
      local harpoon = require('harpoon')
      harpoon:setup()

      vim.keymap.set('n',"<leader>m", function() harpoon:list():add() end)
      vim.keymap.set('n',"<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
      vim.keymap.set({'n', 't'},"<C-j>", function() harpoon:list():select(1) end)
      vim.keymap.set({'n', 't'}, "<C-k>", function() harpoon:list():select(2) end)
    end,
  }
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
