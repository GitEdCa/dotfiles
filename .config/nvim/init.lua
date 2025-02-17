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
-- map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

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
local function term_nav(dir)
	return function(self)
		return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
			vim.cmd.wincmd(dir)
		end)
	end
end
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
        dependencies = {
              { 'williamboman/mason.nvim', opts = {} },
        },
        config = function(_, opts)
            local servers = {
                clangd = {},
                -- pyright = {},
                -- jdtls = {},
                -- rust_analyzer = {},
            }
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
            for server, settings in pairs(servers) do
                -- settings.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                settings.capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
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

                    map('gD', vim.lsp.buf.declaration, 'Go to Declarations')
                    map('gi', vim.lsp.buf.implementation, 'Go to Implementations')
                    map('go', vim.lsp.buf.type_definition, 'Go to Type Definitions')
                    map('gr', vim.lsp.buf.references, 'Go to References')
                    map('gd', function() Snacks.picker.definition() end, 'Go to definition')
                    map('<leader>D', function() Snacks.picker.lsp_definitions() end, "Goto Definition")
                    map('<leader>s', function() Snacks.picker.lsp_symbols() end, "LSP Symbols")
                    map('<leader>S', function() Snacks.picker.lsp_workspace_symbols() end, "LSP Workspace Symbols")

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

        {
            "saghen/blink.cmp",
            dependencies = 'rafamadriz/friendly-snippets',
            -- use a release tag to download pre-built binaries
            version = '*',
            opts = {
                keymap = {
                    preset = "default",
                    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                    ["<CR>"] = { "accept", "fallback" },
                    ["<Esc>"] = {},
                    ["<PageUp>"] = { "scroll_documentation_up", "fallback" },
                    ["<PageDown>"] = { "scroll_documentation_down", "fallback" },
                },
                completion = {
                    list = {
                        selection = { preselect = false, auto_insert = true }
                    }
                },
                appearance = {
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = 'mono'
                },

                sources = {
                    -- default = { 'lsp', 'path', 'snippets', 'buffer' },
                    default = { 'path', 'snippets', 'buffer' },
                },
                cmdline = { enabled = false },
            },
            opts_extend = { "sources.default" }
        },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below

            -- bigfile = { enabled = true },
            -- dashboard = { enabled = false },
            -- explorer = { enabled = false },
            -- indent = { enabled = false },
            -- input = { enabled = false },
            -- picker = { enabled = true },
            -- notifier = { enabled = false },
            -- quickfile = { enabled = true },
            -- scope = { enabled = false },
            -- scroll = { enabled = true },
            -- statuscolumn = { enabled = false },

            notifier = { enabled = false },
            notify = { enabled = false },

            terminal = {
                    win = {
                        keys = {
                            term_normal = {
                                "<esc><esc>", function() return "<C-\\><C-n>" end,
                                mode = "t",
                                expr = true,
                                desc = "Double escpae to normal mode",
                            },
                            q = "hide",
                            ["<esc>"] = "hide",
                            nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
                            nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
                            nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
                            nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
                        }
                    },
                    styles = {
                        float = {
                            border = "rounded"
                        }
                    }
                },
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
            {'<leader>o', function() Snacks.picker.pick("grep", {dirs = {'./libs'}, follow = true, title = "Symbols"}) end, desc = "Buffer Lines" },
            {'<leader>t', function() Snacks.terminal.toggle() end, desc = "Toggle Terminal" },
            {'<leader>n', function() Snacks.terminal.open("ripnote", { auto_close = true, }) end, desc = "Open ripnote"}
        },
    },

    {
        "echasnovski/mini.nvim",
        event = "VeryLazy",
        config = function() require('mini.pairs').setup()
            require('mini.surround').setup()
                require('mini.jump2d').setup({
                    mappings = {
                        start_jumping = 'gw',
                    },
                })
            require('mini.pairs').setup()
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

    {
      "jake-stewart/multicursor.nvim",
      config = function()
        local mc = require("multicursor-nvim")
        mc.setup()

        local set = vim.keymap.set

        -- Add or skip cursor above/below the main cursor.
        set({"n", "x"}, "<A-up>",
          function() mc.lineAddCursor(-1) end)
        set({"n", "x"}, "<A-down>",
          function() mc.lineAddCursor(1) end)

        -- Add or skip adding a new cursor by matching word/selection
        set({"n", "x"}, "<A-n>", function() mc.matchAddCursor(1) end)
        set({"n", "x"}, "<A-N>", function() mc.matchSkipCursor(1) end)

        set({"n", "x"}, "mw", function() mc.operator({ motion = "iw", visual = true }) end)

        -- Press `mWi"ap` will create a cursor in every match of string captured by `i"` inside range `ap`.
        set("n", "mW", mc.operator)

        -- Add all matches in the document
        set({"n", "x"}, "<A-A>", mc.matchAllAddCursors)

        -- Rotate the main cursor.
        set({"n", "x"}, "<left>", mc.nextCursor)
        set({"n", "x"}, "<right>", mc.prevCursor)

        -- Delete the main cursor.
        set({"n", "x"}, "<A-x>", mc.deleteCursor)

        -- Add and remove cursors with control + left click.
        set("n", "<c-leftdrag>", mc.handleMouseDrag)
        set("n", "<c-leftmouse>", mc.handleMouse)

        -- Easy way to add and remove cursors using the main cursor.
        set({"n", "x"}, "<c-q>", mc.toggleCursor)

        -- Clone every cursor and disable the originals.
        set({"n", "x"}, "<leader><c-q>", mc.duplicateCursors)

        set("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          elseif mc.hasCursors() then
            mc.clearCursors()
          else
            -- Default <esc> handler.
          end
        end)

        -- Align cursor columns.
        set("n", "&", mc.alignCursors)

        -- Split visual selections by regex.
        set("x", "S", mc.splitCursors)

        -- Append/insert for each line of visual selections.
        set("x", "I", mc.insertVisual)
        set("x", "A", mc.appendVisual)

        -- match new cursors within visual selections by regex.
        set("x", "M", mc.matchCursors)

        -- Jumplist support
        set({"x", "n"}, "<c-o>", mc.jumpBackward)
        set({"x", "n"}, "<c-i>", mc.jumpForward)

        -- Customize how cursors look.
        local hl = vim.api.nvim_set_hl
        hl(0, "MultiCursorCursor", { link = "Cursor" })
        hl(0, "MultiCursorVisual", { link = "Visual" })
        hl(0, "MultiCursorSign", { link = "SignColumn"})
        hl(0, "MultiCursorMatchPreview", { link = "Search" })
        hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
        hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
        hl(0, "MultiCursorDisabledSign", { link = "SignColumn"})
      end
    },

  },
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
