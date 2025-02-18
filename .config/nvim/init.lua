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
opt.shiftwidth = 4 -- number of spaces inserted for each indentation level
opt.tabstop = 4 -- number of spaces inserted for tab character
opt.softtabstop = 4 -- number of spaces inserted for <Tab> key
opt.smartindent = true -- enable smart indentation
opt.breakindent = true -- enable line breaking indentation

-- General Behaviors
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
vim.g.netrw_banner = 0 -- Netrw hide banner

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

-- command line
vim.o.wildmenu = true -- Set wildmenu command
vim.o.wildmode = "list:longest:full" -- display wildmenu mode


-- [[ keymaps ]]
-- Set our leader keybinding to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
-- Remove search highlights after searching
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Remove search highlights" })

-- Exit Vim's terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

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

-- clipboards hotkeys
map({"n", "v"}, "<leader>y", [["+y]])
map({"n", "v"}, "<leader>Y", [["+Y]])
map({'n', 'v'}, '<leader>p', [["+p"]])
map({'n', 'v'}, '<leader>P', [['"+P]])

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

-- Open Netrw
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)

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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
  spec = {
    -- [[ base plugins ]]
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
        -- 'metalelf0/base16-black-metal-scheme',
        'vague2k/vague.nvim',
        priority = 1000, -- Make sure to load this before all the other start plugins.
        init = function()
            vim.cmd.colorscheme 'vague'
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
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            picker = { enabled = true },
            input = { enabled = true },
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
            -- {'<leader>t', function() Snacks.terminal.toggle() end, desc = "Toggle Terminal" },
            -- {'<leader>n', function() Snacks.terminal.open("ripnote", { auto_close = true, }) end, desc = "Open ripnote"}
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

    {
            'neovim/nvim-lspconfig',
            event = 'VeryLazy',
            dependencies = {
                'williamboman/mason-lspconfig.nvim',
                'williamboman/mason.nvim',
                'hrsh7th/nvim-cmp',
                'hrsh7th/cmp-nvim-lsp',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'L3MON4D3/LuaSnip',
                'saadparwaiz1/cmp_luasnip',
                'rafamadriz/friendly-snippets',
            },
            config = function(_, opts)
                -- [[ LSP config ]]
                vim.api.nvim_create_autocmd('LspAttach', {
                    desc = 'LSP actions',
                    callback = function(event)
                        local opts = {buffer = event.buf}

                        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                        vim.keymap.set('n', '<leader>D', function() Snacks.picker.lsp_definitions() end, opts)
                        vim.keymap.set('n', '<leader>s', function() Snacks.picker.lsp_symbols() end, opts)
                        vim.keymap.set('n', '<leader>S', function() Snacks.picker.lsp_workspace_symbols() end, opts)
                    end,
                })

                --  [[ mason config ]]
                local lspconfig_defaults = require('lspconfig').util.default_config
                lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                    'force',
                    lspconfig_defaults.capabilities,
                    require('cmp_nvim_lsp').default_capabilities()
                )

                require("mason").setup()
                require('mason-lspconfig').setup({
                    ensure_installed = {
                        "clangd",
                        "jdtls",
                        "rust_analyzer",
                        "lua_ls"
                    },
                    handlers = {
                        function(server_name)
                            require('lspconfig')[server_name].setup({})
                        end,
                    }
                })

                -- [[ nvim-cmp ]]
                local cmp = require('cmp')
                require('luasnip.loaders.from_vscode').lazy_load()

                cmp.setup({
                    sources = {
                        {name = 'path'},
                        {name = 'nvim_lsp'},
                        {name = 'luasnip', keyword_length = 2},
                        {name = 'buffer', keyword_length = 3},
                    },
                    window = {
                        completion = cmp.config.window.bordered(),
                        documentation = cmp.config.window.bordered(),
                    },
                    snippet = {
                        expand = function(args)
                            require('luasnip').lsp_expand(args.body)
                        end,
                    },
                    completion = { completeopt = 'menu,menuone,noinsert' }, 
                    mapping = cmp.mapping.preset.insert({
                      ['<C-n>'] = cmp.mapping.select_next_item(),
                      ['<C-p>'] = cmp.mapping.select_prev_item(),
                      ['<C-y>'] = cmp.mapping.confirm { select = true },
                      ['<CR>'] = cmp.mapping.confirm { select = true },
                      ['<Tab>'] = cmp.mapping.select_next_item(),
                      --['<S-Tab>'] = cmp.mapping.select_prev_item(),
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
                    })
                })

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

            end
        },

    -- [[ extras plugins ]]

    {
        'MeanderingProgrammer/render-markdown.nvim',
        event = 'BufEnter',
    },

    {
        'brenoprata10/nvim-highlight-colors',
        event = 'BufEnter',
    },

  },
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = false },
})
