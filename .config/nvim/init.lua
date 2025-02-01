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
vim.o.statusline = "%f"  -- File path
vim.o.statusline = vim.o.statusline .. "%h%w"  -- Help and preview windows
vim.o.statusline = vim.o.statusline .. "%m"  -- Modified flag
vim.o.statusline = vim.o.statusline .. "%r"  -- Read-only flag
vim.o.statusline = vim.o.statusline .. "%="  -- Align the rest to the right
vim.o.statusline = vim.o.statusline .. "%{&filetype}"  -- File type
vim.o.statusline = vim.o.statusline .. " [%{strlen(&fileencoding) > 0 ? &fileencoding : 'none'}]"  -- Encoding
vim.o.statusline = vim.o.statusline .. " %{&fileformat}"  -- File format
vim.o.statusline = vim.o.statusline .. " %{line('.')}"  -- Line number
vim.o.statusline = vim.o.statusline .. "/"  -- Separator
vim.o.statusline = vim.o.statusline .. "%L"  -- Column number / Total lines


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
local data_dir = vim.fn.has('nvim') == 1 and vim.fn.stdpath('data') .. '/site' or vim.fn.expand('~/.vim')
if vim.fn.empty(vim.fn.glob(data_dir .. '/autoload/plug.vim')) == 1 then
  vim.cmd('silent !curl -fLo ' .. data_dir .. '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end


local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
    Plug('tpope/vim-sleuth')
    Plug('tpope/vim-fugitive')
    Plug('vague2k/vague.nvim')
    Plug('dense-analysis/ale')
    Plug('echasnovski/mini.nvim')
    Plug('mbbill/undotree', { on = 'UndotreeToggle' })
    Plug('MeanderingProgrammer/render-markdown.nvim')
    Plug('brenoprata10/nvim-highlight-colors')
    Plug('doums/suit.nvim')
    Plug('neovim/nvim-lspconfig')
    Plug('saghen/blink.cmp', { tag = '*'} )
    Plug('rafamadriz/friendly-snippets')
    Plug('nvim-lua/plenary.nvim')
    Plug('nvim-telescope/telescope.nvim', { tag = '0.1.8' })
vim.call('plug#end')

-- colorscheme
vim.cmd.colorscheme('vague') -- set colorscheme

-- ale
local g = vim.g
-- g.ale_linters = {
-- 	lua = {'lua_language_server'},
-- 	rust = {'analyzer'},
-- 	c = { 'clang', 'gcc', 'cppcheck' },
-- 	cpp = { 'clang', 'gcc', 'cppcheck', 'clang-tidy' },
-- }
--g.ale_linter_aliases = {
--   java = { 'jdtls' }
--}
g.ale_lint_on_text_changed = 0
g.ale_lint_on_insert_leave = 0
g.ale_lint_on_save = 1

-- mini 
require('mini.pairs').setup {}
require('mini.surround').setup()
require('mini.icons').setup()

require('mini.files').setup()
vim.keymap.set('n', '<leader>E', function() MiniFiles.open() end)
vim.keymap.set('n', '<leader>e', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)

-- telescope
require('telescope').setup({
    defaults = {
        path_display = {'truncate'}
    }
})

local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>h', builtin.help_tags)
vim.keymap.set('n', '<leader>f', builtin.find_files)
vim.keymap.set('n', '<leader>,', builtin.builtin)
vim.keymap.set('n', '<leader>g', builtin.grep_string)
vim.keymap.set('n', '<leader>G', builtin.live_grep)
-- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>.', builtin.resume)
vim.keymap.set('n', '<leader><leader>', builtin.buffers)
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find)

-- render-markdown.nvim
require('render-markdown').setup()

-- nvim-highlight-colors
require('nvim-highlight-colors').setup()

-- undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Open UndoTree' })

-- lspconfig
local servers = {
    -- clangd = {},
    -- pyright = {},
    -- jdtls = {},
    -- rust_analyzer = {},
}
for server, settings in pairs(servers) do
    settings.capabilities = require('blink.cmp').get_lsp_capabilities()
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
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')
        map('<leader>s', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
        map('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

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
        -- activate suit only when lsp is running
        require('suit').setup()

    end,
})

-- blink.cmp
local blink = require('blink.cmp').setup({
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
    sources = {
        cmdline = {},
    },
})

-- rlbook
local rlbook = require('rlbook')
vim.keymap.set('n', '<leader>1', function() rlbook.save_bookmark(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>2', function() rlbook.save_bookmark(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>3', function() rlbook.save_bookmark(3) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-1>', function() rlbook.goto_bookmark(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-2>', function() rlbook.goto_bookmark(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-3>', function() rlbook.goto_bookmark(3) end, { noremap = true, silent = true })
