-- [[ options ]]
-- Left column and similar settings
vim.opt.number = true -- display line numbers
vim.opt.relativenumber = true -- display relative line numbers
vim.opt.numberwidth = 2 -- set width of line number column
vim.opt.signcolumn = "yes" -- always show sign column
vim.opt.wrap = false -- display lines as single line
vim.opt.scrolloff = 10 -- number of lines to keep above/below cursor
vim.opt.sidescrolloff = 8 -- number of columns to keep to the left/right of cursor

-- Tab spacing/behavior
-- vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 4 -- number of spaces inserted for each indentation level
vim.opt.tabstop = 4 -- number of spaces inserted for tab character
vim.opt.softtabstop = 4 -- number of spaces inserted for <Tab> key
vim.opt.smartindent = true -- enable smart indentation
vim.opt.breakindent = true -- enable line breaking indentation

-- General Behaviors
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.backup = false -- disable backup file creation
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8" -- set file encoding to UTF-8
vim.opt.mouse = "a" -- enable mouse support
vim.opt.showmode = false -- hide mode display
vim.opt.splitbelow = true -- force horizontal splits below current window
vim.opt.splitright = true -- force vertical splits right of current window
vim.opt.termguicolors = true -- enable term GUI colors
vim.opt.timeoutlen = 1000 -- set timeout for mapped sequences
vim.opt.undofile = true -- enable persistent undo
vim.opt.undodir        = os.getenv("HOME") .. "/.vim/undodir" -- set undo dir
vim.opt.updatetime = 100 -- set faster completion
vim.opt.writebackup = false -- prevent editing of files being edited elsewhere
vim.opt.cursorline = true -- highlight current line
vim.opt.list = true -- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- chars to display

-- Searching Behaviors
vim.opt.hlsearch = true -- highlight all matches in search
vim.opt.ignorecase = true -- ignore case in search
vim.opt.smartcase = true -- match case if explicitly stated
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!

-- statusline
vim.o.laststatus = 2  -- Always show the status line
vim.o.statusline = table.concat({
    "%#PmenuSel#",      -- Highlight group
    " %f ",             -- File name
    "%m",               -- Modified flag [+]
    "%#Normal#",        -- Reset highlight
    "%=",               -- Right align
    "%y ",              -- File type
    "[%l/%L] ",         -- Current line / Total lines
    "%c ",              -- Column number
})

-- [[ keymaps ]]
-- Set our leader keybinding to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Remove search highlights after searching
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

-- Exit Vim's terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ins-completion suggestions
vim.keymap.set('i', '<C-]>', '<C-x><C-]>', { noremap = true } )
vim.keymap.set('i', '<C-F>', '<C-x><C-f>', { noremap = true } )
vim.keymap.set('i', '<C-D>', '<C-x><C-d>', { noremap = true } )
vim.keymap.set('i', '<C-L>', '<C-x><C-l>', { noremap = true } )

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left in visual mode" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right in visual mode" })

-- yank behaviour like D or C
vim.keymap.set('n', 'Y', 'y$')

-- auto format just pasted text
vim.keymap.set({ 'n', 'x' }, '<leader>=', "'[=']")

-- duplicate current line and preserved cursor position
vim.keymap.set({ 'n', 'i' } , '<A-t>', '<cmd>:t.<CR>')

-- save with C-s
vim.keymap.set({ 'x', 'n', 'i' }, '<C-s>', '<Esc><cmd>up<CR><ESC>')

-- open last buffer with Backspace key
vim.keymap.set('n', '<BS>', ':b#<CR>')

-- kj as esc
vim.keymap.set('i', 'kj', '<Esc>', { noremap = true, silent = true })

-- clipboards hotkeys
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set({"n", "v"}, "<leader>Y", [["+Y]])
vim.keymap.set({'n', 'v'},'<leader>p', [["+p"]])
vim.keymap.set({'n', 'v'},'<leader>P', [['"+P]])

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
        desc = 'Highlight when yanking (copying) text',
        group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
        callback = function()
                vim.highlight.on_yank()
        end,
})

vim.api.nvim_create_autocmd('TermOpen', {
        desc = 'No numbers for terminals',
        group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
        callback = function()
            vim.opt.number = false
            vim.opt.relativenumber = false
        end,
})

-- [[ plugins ]]
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here
    {
        'tpope/vim-sleuth',
        event = 'BufEnter',
    },

    {
        'tpope/vim-fugitive',
        cmd = 'Git'
    },

    {
        'metalelf0/base16-black-metal-scheme',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        init = function()
            vim.cmd.colorscheme 'base16-black-metal-gorgoroth'
        end,
    },

    {
        'dense-analysis/ale',
        event = 'BufEnter',
        config = function(_, opts)
            local g = vim.g
            -- g.ale_linters = {
                --      lua = {'lua_language_server'},
                --      rust = {'analyzer'},
                --      c = { 'clang', 'gcc', 'cppcheck' },
                --      cpp = { 'clang', 'gcc', 'cppcheck', 'clang-tidy' },
                -- }
            -- g.ale_linter_aliases = { java = { 'jdtls' } }
            g.ale_lint_on_text_changed = 0
            g.ale_lint_on_insert_leave = 0
            g.ale_lint_on_save = 1
        end,
    },

    {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        keys = {
            {'<leader>u', vim.cmd.UndotreeToggle, desc = "Toggle Undotree" }
        }
    },

    {
        'MeanderingProgrammer/render-markdown.nvim',
        event = 'BufEnter *.md',
    },

    {
        'brenoprata10/nvim-highlight-colors',
        event = 'BufEnter',
    },

    {
        'neovim/nvim-lspconfig',
        event = 'VeryLazy',
        config = function(_, opts)
            local servers = {
                -- clangd = {},
                -- pyright = {},
                -- jdtls = {},
                -- rust_analyzer = {},
            }
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
            for server, settings in pairs(servers) do
                settings.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                require("lspconfig")[server].setup(settings)
            end
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end
                    local opts = { buffer = bufnr }
                    map('gd', vim.lsp.buf.definition, 'Go to definition')
                    map('gD', vim.lsp.buf.declaration, 'Go to Declarations')
                    map('gi', vim.lsp.buf.implementation, 'Go to Implementations')
                    map('go', vim.lsp.buf.type_definition, 'Go to Type Definitions')
                    map('gr', vim.lsp.buf.references, 'Go to References')
                    -- map('<leader>D', require('fzf-lua').lsp_typedefs, 'Type Definition')
                    -- map('<leader>s', require('fzf-lua').lsp_document_symbols, 'Document Symbols')
                    -- map('<leader>S', require('fzf-lua').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

                    map('<leader>D', function() Snacks.picker.lsp_definitions() end, "Goto Definition")
                    map('<leader>s', function() Snacks.picker.lsp_symbols() end, "LSP Symbols")
                    map('<leader>S', function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")

                    map('<leader>r', vim.lsp.buf.rename, 'Rename')
                    vim.keymap.set({ 'n', 'x' }, '<leader>F', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    map('<leader>a', vim.lsp.buf.code_action, 'Open code actions')

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map('<leader>th', function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                        end, '[T]oggle Inlay [H]ints')
                    end
                    vim.diagnostic.config({
                        -- update_in_insert = true,
                        float = {
                            focusable = false,
                            style = "minimal",
                            border = "rounded",
                            source = "always",
                            header = "",
                            prefix = "",
                        },
                    })
                end,
            })
        end,
    },

    { -- Autocompletion
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        version = false, -- last release is way too old
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                'L3MON4D3/LuaSnip',
                build = (function()
                    if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
                        return
                    end
                    return 'make install_jsregexp'
                end)(),
                dependencies = {
                    -- `friendly-snippets` contains a variety of premade snippets.
                    --    See the README about individual language/framework/plugin snippets:
                    --    https://github.com/rafamadriz/friendly-snippets
                            {
                                'rafamadriz/friendly-snippets',
                                config = function()
                                    require('luasnip.loaders.from_vscode').lazy_load()
                                end,
                            },
                        },
                    },
                    'saadparwaiz1/cmp_luasnip',

                    -- Adds other completion capabilities.
                    --  nvim-cmp does not ship with all sources by default. They are split
                    --  into multiple repos for maintenance purposes.
                    'hrsh7th/cmp-nvim-lsp',
                    'hrsh7th/cmp-path',
                    "hrsh7th/cmp-buffer",
                },
                config = function()
                    -- See `:help cmp`
                    local cmp = require 'cmp'
                    local luasnip = require 'luasnip'
                    luasnip.config.setup {}

                    cmp.setup {
                        snippet = {
                            expand = function(args)
                                luasnip.lsp_expand(args.body)
                            end,
                        },
                        -- completion = { autocomplete = false, completeopt = 'menu,menuone,noinsert' },
                        completion = { completeopt = 'menu,menuone,noinsert' },

                        -- For an understanding of why these mappings were
                        -- chosen, you will need to read `:help ins-completion`
                        --
                        -- No, but seriously. Please read `:help ins-completion`, it is really good!
                        mapping = cmp.mapping.preset.insert {
                            -- Select the [n]ext item
                            ['<C-n>'] = cmp.mapping.select_next_item(),
                            -- Select the [p]revious item
                            ['<C-p>'] = cmp.mapping.select_prev_item(),

                            -- Scroll the documentation window [b]ack / [f]orward
                            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                            ['<C-f>'] = cmp.mapping.scroll_docs(4),

                            -- Accept ([y]es) the completion.
                            --  This will auto-import if your LSP supports it.
                            --  This will expand snippets if the LSP sent a snippet.
                            ['<C-y>'] = cmp.mapping.confirm { select = true },

                            -- If you prefer more traditional completion keymaps,
                            -- you can uncomment the following lines
                            --['<CR>'] = cmp.mapping.confirm { select = true },
                            --['<Tab>'] = cmp.mapping.select_next_item(),
                            --['<S-Tab>'] = cmp.mapping.select_prev_item(),

                            -- Manually trigger a completion from nvim-cmp.
                            --  Generally you don't need this, because nvim-cmp will display
                            --  completions whenever it has completion options available.
                            ['<C-Space>'] = cmp.mapping.complete {},

                            -- Think of <c-l> as moving to the right of your snippet expansion.
                            --  So if you have a snippet that's like:
                            --  function $name($args)
                            --    $body
                            --  end
                            --
                            -- <c-l> will move you to the right of each of the expansion locations.
                            -- <c-h> is similar, except moving you backwards.
                            ['<C-l>'] = cmp.mapping(function()
                                if luasnip.expand_or_locally_jumpable() then
                                    luasnip.expand_or_jump()
                                end
                            end, { 'i', 's' }),
                            ['<C-h>'] = cmp.mapping(function()
                                if luasnip.locally_jumpable(-1) then
                                    luasnip.jump(-1)
                                end
                            end, { 'i', 's' }),

                            -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                            --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
                        },
                        sources = {
                            { name = 'nvim_lsp' },
                            { name = 'luasnip' },
                            { name = 'path' },
                        }, {
                            { name = "buffer" },
                        },
                    }
                end,
            },

    -- { -- Fuzzy Finder (files, lsp, etc)
    --     'nvim-telescope/telescope.nvim',
    --     event = 'VimEnter',
    --     branch = '0.1.x',
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         {
    --             'nvim-telescope/telescope-fzf-native.nvim',
    --             build = 'make',
    --             cond = function()
    --                 return vim.fn.executable 'make' == 1
    --             end,
    --         },
    --         { 'nvim-telescope/telescope-ui-select.nvim' },
    --     },
    --     keys = {
    --         {'<leader>h', "<cmd>Telescope help_tags<cr>"},
    --         {'<leader>f', "<cmd>Telescope find_files<cr>"},
    --         {'<leader>,', "<cmd>Telescope builtin<cr>"},
    --         {'<leader>g', "<cmd>Telescope grep_string<cr>"},
    --         {'<leader>G', "<cmd>Telescope live_grep<cr>"},
    --         {'<leader>q', "<cmd>Telescope diagnostics_workspace<cr>"},
    --         {'<leader>.', "<cmd>Telescope resume<cr>"},
    --         {'<leader><leader>', "<cmd>Telescope buffers<cr>"},
    --         {'<leader>/', "<cmd>Telescope current_buffer_fuzzy_find<cr>"},
    --         {'<leader>t', "<cmd>Telescope tags<cr>"},
    --     },
    --     config = function()
    --         -- See `:help telescope` and `:help telescope.setup()`
    --         require('telescope').setup {
    --             defaults = {
    --                 path_display = { "truncate" },
    --             },
    --             -- defaults = {
    --             --   mappings = {
    --             --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
    --             --   },
    --             -- },
    --             -- pickers = {}
    --             extensions = {
    --                 ['ui-select'] = {
    --                     require('telescope.themes').get_dropdown(),
    --                 },
    --             },
    --         }
    --
    --         -- Enable Telescope extensions if they are installed
    --         pcall(require('telescope').load_extension, 'fzf')
    --         pcall(require('telescope').load_extension, 'ui-select')
    --     end,
    -- },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = false },
            indent = { enabled = false },
            input = { enabled = false },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = false },
            scroll = { enabled = true },
            statuscolumn = { enabled = false },
            words = { enabled = false },
        },
        keys = {
            {'<leader>h', function() Snacks.picker.help() end, desc = "Help Pages" },
            {'<leader>f', function() Snacks.picker.files() end, desc = "Find Files" },
            {'<leader>,', function() Snacks.picker.pickers() end, desc = "Find all available pickers" },
            {'<leader>g', function() Snacks.picker.grep() end, desc = "Grep" },
            {'<leader>G', function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x"} },
            {'<leader>q', function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
            {'<leader>.', function() Snacks.picker.resume() end, desc = "Resume" },
            {'<leader><leader>', function() Snacks.picker.buffers() end, desc = "Buffers" },
            {'<leader>/', function() Snacks.picker.lines() end, desc = "Buffer Lines" },
            -- {'<leader>t', "<cmd>Telescope tags<cr>"},
        },
    },

    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        opts = {
            modes = { insert = true, command = true, terminal = false },
            -- skip autopair when next character is one of these
            skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
            -- skip autopair when the cursor is inside these treesitter nodes
            skip_ts = { "string" },
            -- skip autopair when next character is closing pair
            -- and there are more closing pairs than opening pairs
            skip_unbalanced = true,
            -- better deal with markdown code blocks
            markdown = true,
        },
    },

    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = 'VeryLazy',
        main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        opts = {
            ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'java' },
            -- Autoinstall languages that are not installed
            auto_install = false,
            highlight = {
                enable = true,
            },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    node_incremental = "v",
                    node_decremental = "V",
                },
            },
        },
        -- There are additional nvim-treesitter modules that you can use to interact
        -- with nvim-treesitter. You should go explore a few and see what interests you:
        --
        --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
        --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

    },

  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
