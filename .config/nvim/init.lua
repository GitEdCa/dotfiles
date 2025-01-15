-- [[ Setting options ]]
vim.g.mapleader = ' '
vim.opt.mouse = 'a'
-- copy to system clipboard by default
vim.opt.clipboard = 'unnamedplus'
-- enable icons
-- vim.opt.breakindent    = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
-- Keep signcolumn on by default
vim.opt.updatetime     = 250
-- Configure how new splits should be opened
vim.opt.splitright     = true
vim.opt.splitbelow     = true
-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list           = true
vim.opt.listchars      = { tab = '» ', trail = '·', nbsp = '␣' }
-- Preview substitutions live, as you type!
vim.opt.inccommand     = 'split'
-- Show which line your cursor is on
vim.opt.cursorline     = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff      = 8

-- vim.opt.guicursor      = ""
vim.opt.nu             = true
vim.opt.relativenumber = true
-- vim.opt.tabstop        = 4
-- vim.opt.softtabstop    = 4
-- vim.opt.shiftwidth     = 4
-- vim.opt.smartindent    = true
-- vim.opt.wrap           = false
-- vim.opt.swapfile       = false
-- vim.opt.backup         = false
-- vim.opt.undodir        = os.getenv("HOME") .. "/.undodir"
-- vim.opt.undofile       = true
-- vim.opt.hlsearch       = false
-- vim.opt.incsearch      = true
vim.opt.termguicolors  = true
vim.opt.signcolumn     = "yes"
vim.opt.colorcolumn    = "80"

-- [[ Basic keymaps ]]
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
-- escape hotkeys
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
vim.keymap.set('i', '<C-c>', '<Esc>')
-- save with C-s
vim.keymap.set({ 'x', 'n', 'i' }, '<C-s>', '<Esc><cmd>up<CR><ESC>')
-- yank behaviour like D or C
vim.keymap.set('n', 'Y', 'y$')
-- auto format just pasted text
vim.keymap.set({ 'n', 'x' }, '<leader>=', "'[=']")
-- ; for commands
-- vim.keymap.set("n", ";", ":")
-- suggestions by ins-completion
vim.keymap.set('i', '<C-]>', '<C-x><C-]>', { noremap = true } )
vim.keymap.set('i', '<C-f>', '<C-x><C-f>', { noremap = true } )
vim.keymap.set('i', '<C-d>', '<C-x><C-d>', { noremap = true } )
vim.keymap.set('i', '<C-l>', '<C-x><C-l>', { noremap = true } )
-- duplicate current line and preserved cursor position
vim.keymap.set({ 'n', 'i' } , '<A-t>', '<cmd>:t.<CR>')
-- quickfix keys
vim.keymap.set('n', '[q', '<cmd>cprev<cr>')
vim.keymap.set('n', ']q', '<cmd>cnext<cr>')
-- open last buffer with Backspace key
vim.keymap.set('n', '<BS>', ':b#<CR>')
-- netrw
vim.keymap.set('n', '<leader>e', ':Explore<CR>')

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- start insert mode when moving to a terminal window
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  callback = function()
    if vim.bo.buftype == 'terminal' then vim.cmd('startinsert') end
  end,
  group = vim_term
})

-- automatic marks per file
vim.cmd[[
  augroup AutomaticMarks
    autocmd!
    autocmd BufLeave *.css,*.scss normal! mC
    autocmd BufLeave *.html       normal! mH
    autocmd BufLeave *.js,*.ts    normal! mJ
    autocmd BufLeave *.vue        normal! mV
    autocmd BufLeave *.yml,*.yaml normal! mY
    autocmd BufLeave .env*        normal! mE
    autocmd BufLeave *.md         normal! mM
    autocmd BufLeave *.lua        normal! mL
  augroup END
]]

-- linting
vim.cmd [[
  augroup Linting
	  autocmd!
	  autocmd FileType rust setlocal makeprg=cargo\ build
	  "autocmd FileType c,cpp setlocal makeprg=make
	  "autocmd FileType c,cpp setlocal efm=%.%#:\ %f:%l:%c:\ %m
	  "autocmd BufWritePost *.rs AsyncDo cargo build
	  "autocmd BufWritePost *.c,*.cpp AsyncDo xmake
	  autocmd QuickFixCmdPost [^l]* cwindow
  augroup END
]]
local function RunAsyncDoWithMakePrg()
    local makeprg_value = vim.opt.makeprg:get()
    vim.fn["asyncdo#run"](0, makeprg_value)
end
vim.keymap.set('n', '<F9>', RunAsyncDoWithMakePrg, { noremap = true, silent = true})

-- [[ Plugins ]]
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
	Plug('tpope/vim-fugitive', { ['on'] = 'Git' })
	Plug('echasnovski/mini.nvim')
	Plug('ibhagwan/fzf-lua')
	Plug('mbbill/undotree', { ['on'] = 'UndotreeToggle'})
	Plug("neovim/nvim-lspconfig")
	Plug("hauleth/asyncdo.vim")

	Plug("MeanderingProgrammer/render-markdown.nvim")
	Plug('norcalli/nvim-colorizer.lua')
	Plug('rebelot/kanagawa.nvim')
	Plug('Saghen/blink.cmp', {['on'] = '*'})
	Plug('rafamadriz/friendly-snippets')
vim.call('plug#end')

-- [[ nvim-colorizer ]]
require('colorizer').setup()

-- [[ colorscheme ]]
vim.cmd('silent! colorscheme kanagawa-dragon')

-- [[ mini.completion ]]
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

-- [[ undotree]]
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle )

-- [[ lspconfig]]
local servers = {
	rust_analyzer = {
		filetypes = { "rust" },
		settings = {
			['rust-analyzer'] = {
				cargo = {
					allFeatures = true,
				},
			},
		},
	},
	clangd = {},
	pyright = {},
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
    local builtin = require('fzf-lua')
    map('K', vim.lsp.buf.hover, 'SHow info over cursor')
    map('gd', vim.lsp.buf.definition, 'Go to definition')
    map('gD', vim.lsp.buf.declaration, 'Go to Declarations')
    map('gi', vim.lsp.buf.implementation, 'Go to Implementations')
    map('go', vim.lsp.buf.type_definition, 'Go to Type Definitions')
    map('gr', vim.lsp.buf.references, 'Go to References')
    -- vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature help', {'i', 'n'})
    map('<leader>r', vim.lsp.buf.rename, 'Rename')
    map('<leader>F', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', 'Format', { 'n', 'x' })
    map('<leader>a', builtin.lsp_code_actions, 'Open code actions')
    map("<C-k>", vim.diagnostic.open_float, 'Show error line')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
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

-- [[ fzf-lua ]]
local builtin = require 'fzf-lua'
vim.keymap.set('n', '<leader>h', builtin.helptags)
vim.keymap.set('n', '<leader>f', builtin.files)
vim.keymap.set('n', '<leader>,', builtin.builtin)
vim.keymap.set('n', '<leader>G', builtin.live_grep)
vim.keymap.set('n', '<leader>g', builtin.grep_cword)
vim.keymap.set('n', '<leader>.', builtin.resume)
vim.keymap.set('n', '<leader><leader>', builtin.buffers)
vim.keymap.set('n', '<leader>/', builtin.blines)

-- [[ netrw ]]
vim.g.netrw_keepdir = 0
vim.g.netrw_liststyle = 1
vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = 'cp -r'
vim.g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]

-- [[ rlbook ]]
local rlbook = require('rlbook')
vim.keymap.set('n', '<leader>1', function() rlbook.save_bookmark(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>2', function() rlbook.save_bookmark(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>3', function() rlbook.save_bookmark(3) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-1>', function() rlbook.goto_bookmark(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-2>', function() rlbook.goto_bookmark(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-3>', function() rlbook.goto_bookmark(3) end, { noremap = true, silent = true })


