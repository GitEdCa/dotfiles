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
vim.opt.clipboard = "unnamedplus" -- enable system clipboard access
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


-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
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
    Plug('lewis6991/gitsigns.nvim')
    Plug('catppuccin/nvim')
    Plug('dense-analysis/ale')
    Plug('echasnovski/mini.nvim')
    Plug('maxbrunsfeld/vim-yankstack')
    Plug('mbbill/undotree', { on = 'UndotreeToggle' })
    Plug('MeanderingProgrammer/render-markdown.nvim')
    Plug('brenoprata10/nvim-highlight-colors')
    Plug('doums/suit.nvim')
    Plug('neovim/nvim-lspconfig')
vim.call('plug#end')

vim.cmd.colorscheme('catppuccin') -- set colorscheme

-- gitsigns
require('gitsigns').setup({
    signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
    },
})

-- ale
local g = vim.g
-- g.ale_linters = {
-- 	lua = {'lua_language_server'},
-- 	rust = {'analyzer'},
-- 	c = { 'clang', 'gcc', 'cppcheck' },
-- 	cpp = { 'clang', 'gcc', 'cppcheck', 'clang-tidy' },
-- }
g.ale_lint_on_save = 1
g.ale_lint_on_text_changed = 0
g.ale_lint_on_insert_leave = 0

-- mini 
require('mini.indentscope').setup {}
require('mini.pairs').setup {}
require('mini.bracketed').setup {}
require('mini.surround').setup()
require('mini.jump2d').setup({
    mappings = {
        start_jumping = 'gw',
    },
})
require('mini.icons').setup()

local statusline = require 'mini.statusline'
statusline.setup { use_icons = false }
statusline.section_location = function()
    return '%2l:%-2v'
end

require('mini.files').setup()
vim.keymap.set('n', '<leader>E', function() MiniFiles.open() end)
vim.keymap.set('n', '<leader>e', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)

-- tab to complete
require('mini.completion').setup()
local imap_expr = function(lhs, rhs)
    vim.keymap.set('i', lhs, rhs, { expr = true })
end
imap_expr('<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])
local keycode = vim.keycode or function(x)
    return vim.api.nvim_replace_termcodes(x, true, true, true)
end
local keys = {
    ['cr']        = keycode('<CR>'),
    ['ctrl-y']    = keycode('<C-y>'),
    ['ctrl-y_cr'] = keycode('<C-y><CR>'),
}

_G.cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
        local item_selected = vim.fn.complete_info()['selected'] ~= -1
        return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
    else
        return keys['cr']
    end
end
vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })

require('mini.pick').setup()
vim.keymap.set('n', '<leader>f', function() MiniPick.builtin.files() end)
vim.keymap.set('n', '<leader>F', function() MiniPick.builtin.git() end)
vim.keymap.set('n', '<leader>g', function() MiniPick.builtin.grep() end)
vim.keymap.set('n', '<leader>G', function() MiniPick.builtin.grep_live() end)
vim.keymap.set('n', '<leader>h', function() MiniPick.builtin.help() end)
vim.keymap.set('n', '<leader>,', function() MiniPick.builtin.resume() end)
vim.keymap.set('n', '<leader><leader>', function() MiniPick.builtin.buffers() end)

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

-- suit.nvim
require('suit').setup()

-- rlbook
local rlbook = require('rlbook')
vim.keymap.set('n', '<leader>1', function() rlbook.save_bookmark(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>2', function() rlbook.save_bookmark(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>3', function() rlbook.save_bookmark(3) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-1>', function() rlbook.goto_bookmark(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-2>', function() rlbook.goto_bookmark(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-3>', function() rlbook.goto_bookmark(3) end, { noremap = true, silent = true })
