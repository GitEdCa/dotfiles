-- [[ options ]]
-- Left column and similar settings
local opt = vim.opt
opt.number = true -- display line numbers
opt.relativenumber = true -- display relative line numbers
opt.numberwidth = 2 -- set width of line number column
opt.signcolumn = "yes" -- always show sign column
opt.wrap = false -- display lines as single line
opt.scrolloff = 10 -- number of lines to keep above/below cursor
opt.sidescrolloff = 8 -- number of columns to keep to the left/right of cursor

-- Tab spacing/behavior
-- opt.expandtab = true -- convert tabs to spaces
opt.shiftwidth = 4 -- number of spaces inserted for each indentation level
opt.tabstop = 4 -- number of spaces inserted for tab character
opt.softtabstop = 4 -- number of spaces inserted for <Tab> key
opt.smartindent = true -- enable smart indentation
opt.breakindent = true -- enable line breaking indentation

-- General Behaviors
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
opt.backup = false -- disable backup file creation
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- set file encoding to UTF-8
opt.mouse = "a" -- enable mouse support
opt.showmode = false -- hide mode display
opt.splitbelow = true -- force horizontal splits below current window
opt.splitright = true -- force vertical splits right of current window
opt.termguicolors = true -- enable term GUI colors
opt.timeoutlen = 1000 -- set timeout for mapped sequences
opt.undofile = true -- enable persistent undo
opt.undodir        = os.getenv("HOME") .. "/.vim/undodir" -- set undo dir
opt.updatetime = 100 -- set faster completion
opt.writebackup = false -- prevent editing of files being edited elsewhere
opt.cursorline = true -- highlight current line
opt.list = true -- Sets how neovim will display certain whitespace characters in the editor.
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- chars to display

-- Searching Behaviors
opt.hlsearch = true -- highlight all matches in search
opt.ignorecase = true -- ignore case in search
opt.smartcase = true -- match case if explicitly stated
opt.inccommand = 'split' -- Preview substitutions live, as you type!

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

local map = vim.keymap.set
-- Remove search highlights after searching
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

-- Exit Vim's terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- ins-completion suggestions
map('i', '<C-]>', '<C-x><C-]>', { noremap = true } )
map('i', '<C-F>', '<C-x><C-f>', { noremap = true } )
map('i', '<C-D>', '<C-x><C-d>', { noremap = true } )
map('i', '<C-L>', '<C-x><C-l>', { noremap = true } )

-- Better window navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Stay in indent mode
map("v", "<", "<gv", { desc = "Indent left in visual mode" })
map("v", ">", ">gv", { desc = "Indent right in visual mode" })

-- yank behaviour like D or C
map('n', 'Y', 'y$')

-- auto format just pasted text
map({ 'n', 'x' }, '<leader>=', "'[=']")

-- duplicate current line and preserved cursor position
map({ 'n', 'i' } , '<A-t>', '<cmd>:t.<CR>')

-- save with C-s
map({ 'x', 'n', 'i', 's' }, '<C-s>', '<Esc><cmd>up<CR><ESC>')

-- open last buffer with Backspace key
map('n', '<leader>`', ':b#<CR>')

-- kj as esc
map('i', 'kj', '<Esc>', { noremap = true, silent = true })

-- clipboards hotkeys
map({"n", "v"}, "<leader>y", [["+y]])
map({"n", "v"}, "<leader>Y", [["+Y]])
map({'n', 'v'},'<leader>p', [["+p"]])
map({'n', 'v'},'<leader>P', [['"+P]])

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

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
        'NMAC427/guess-indent.nvim',
        event = 'BufEnter',
        opts = {},
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
        event = 'BufEnter',
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
                    local builtin = require 'telescope.builtin'
                    map('gd', builtin.lsp_definitions, 'Go to definition')
                    map('gD', vim.lsp.buf.declaration, 'Go to Declarations')
                    map('gi', vim.lsp.buf.implementation, 'Go to Implementations')
                    map('go', vim.lsp.buf.type_definition, 'Go to Type Definitions')
                    map('gr', vim.lsp.buf.references, 'Go to References')
                    map('<leader>D', builtin.lsp_type_definitions, 'Type Definition')
                    map('<leader>s', builtin.lsp_document_symbols, 'Document Symbols')
                    map('<leader>S', builtin.lsp_dynamic_workspace_symbols, 'Workspace Symbols')

                    map('<leader>r', vim.lsp.buf.rename, 'Rename')
                    vim.keymap.set({ 'n', 'x' }, '<leader>F', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    map('<leader>a', vim.lsp.buf.code_action, 'Open code actions')

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map('<leader>Li', function()
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
                            {
                                'rafamadriz/friendly-snippets',
                                config = function()
                                    require('luasnip.loaders.from_vscode').lazy_load()
                                end,
                            },
                        },
                    },
                    'saadparwaiz1/cmp_luasnip',
                    'hrsh7th/cmp-nvim-lsp',
                    'hrsh7th/cmp-path',
                    "hrsh7th/cmp-buffer",
                },
                config = function()
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

    { -- Fuzzy Finder (files, lsp, etc)
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
        },
        keys = {
            {'<leader>h', "<cmd>Telescope help_tags<cr>"},
            {'<leader>f', "<cmd>Telescope find_files<cr>"},
            {'<leader>,', "<cmd>Telescope builtin<cr>"},
            {'<leader>g', "<cmd>Telescope grep_string<cr>"},
            {'<leader>G', "<cmd>Telescope live_grep<cr>"},
            {'<leader>q', "<cmd>Telescope diagnostics_workspace<cr>"},
            {'<leader>.', "<cmd>Telescope resume<cr>"},
            {'<leader><leader>', "<cmd>Telescope buffers<cr>"},
            {'<leader>/', "<cmd>Telescope current_buffer_fuzzy_find<cr>"},
        },
        config = function()
            -- See `:help telescope` and `:help telescope.setup()`
            require('telescope').setup {
                defaults = {
                    path_display = { "truncate" },
                },
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }

            -- Enable Telescope extensions if they are installed
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')
        end,
    },

    {
        "echasnovski/mini.nvim",
        event = "VeryLazy",
        config = function() require('mini.pairs').setup()
            require('mini.surround').setup()
            require('mini.jump2d').setup()
        end,
    },

    { -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = 'VeryLazy',
        main = 'nvim-treesitter.configs', -- Sets main module to use for opts
        -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
        opts = {
            ensure_installed = { 'javascript', 'python', 'typescript', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'java' },
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
        --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    },

  },
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
