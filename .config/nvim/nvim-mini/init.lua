-- [[ options ]]
-- set leader
vim.g.mapleader = ' '
-- Save undo history
vim.opt.undofile = true
vim.opt.termguicolors = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- mark trailing spaces as errors
vim.cmd[[match IncSearch '\s\+$']]
-- copy & paste mapping to clipboard using leader
--Yank into system clipboard
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y') -- yank motion
vim.keymap.set({'n', 'v'}, '<leader>Y', '"+Y') -- yank line
-- Delete into system clipboard
vim.keymap.set({'n', 'v'}, '<leader>d', '"+d') -- delete motion
vim.keymap.set({'n', 'v'}, '<leader>D', '"+D') -- delete line
-- Paste from system clipboard
vim.keymap.set('n', '<leader>p', '"+p')  -- paste after cursor
vim.keymap.set('n', '<leader>P', '"+P')  -- paste before cursor
-- hotkeys quickfix
vim.keymap.set('n', '[q', '<cmd>cprev<CR>zz')
vim.keymap.set('n', ']q', '<cmd>cnext<CR>zz')
-- exit with double esc from terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- move lines
vim.keymap.set('n', '<C-k>', '<C-W>k', {desc = 'Focus right panel'})
vim.keymap.set('n', '<C-j>', '<cmd>m +1<cr>')
vim.keymap.set('v', '<C-j>', '<cmd>m +2<cr>')
vim.keymap.set('v', '<C-k>', '<cmd>m -3<CR>')
--autocommands
vim.api.nvim_create_autocmd({'BufEnter', 'BufNewFile'}, {
  desc = 'Set syntax asciidoc',
  pattern = "{*.txt}",
  group = vim.api.nvim_create_augroup('set-asciidoc-syntax', { clear = true }),
  callback = function()
	  vim.cmd[[set syntax=asciidoc]]
  end,
})
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ plugins ]]
-- Set up 'mini.deps' (customize to your liking)
-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require('mini.deps').setup({ path = { package = path_package } })
require('mini.clue').setup()
require('mini.completion').setup({
  lsp_completion = {
    source_func = 'omnifunc',
    auto_setup = false,
  }
})
require('mini.statusline').setup()
require('mini.extra').setup()
require('mini.notify').setup()
require('mini.jump').setup()
require('mini.jump2d').setup()
require('mini.cursorword').setup()
require('mini.indentscope').setup()
require('mini.starter').setup()
require('mini.sessions').setup({
  directory = vim.fn.stdpath("config") .. '/sessions',
})
require('mini.files').setup()
vim.keymap.set('n', '<leader>E', function() MiniFiles.open() end)
-- mini.pick
require('mini.pick').setup({
  mappings = { choose_marked = '<C-q>', mark_all = '<C-e>'},
  window = { config = function()
		  height = math.floor(0.618 * vim.o.lines)
		  width = math.floor(0.618 * vim.o.columns)
		  return {
				  anchor = 'NW', height = height, width = width,
				  row = math.floor(0.5 * (vim.o.lines - height)),
				  col = math.floor(0.5 * (vim.o.columns - width)),} end},
})
vim.keymap.set('n', '<leader>f', function() MiniPick.builtin.files() end)
vim.keymap.set('n', '<leader>F', function() MiniPick.builtin.git() end)
vim.keymap.set('n', '<leader>g', function() MiniPick.builtin.grep_live() end)
vim.keymap.set('n', '<leader>h', function() MiniPick.builtin.help() end)
vim.keymap.set('n', '<leader>s', function() MiniExtra.pickers.lsp({scope = 'document_symbol'}) end)
vim.keymap.set('n', '<leader>S', function() MiniExtra.pickers.lsp({scope = 'workspace_symbol'}) end)
vim.keymap.set('n', '<leader>b', function() MiniPick.builtin.buffers() end)
vim.keymap.set('n', '<leader>/', function() MiniExtra.pickers.buf_lines() end)
MiniDeps.add({
  source = 'neovim/nvim-lspconfig',
  depends = { 'williamboman/mason.nvim'},
})

require("mason").setup()

local lspconfig = require('lspconfig')
lspconfig.clangd.setup {}
lspconfig.pyright.setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>t', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>.', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<C-e>', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>dF', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- Vim-sleuth
MiniDeps.add({
  source = 'tpope/vim-sleuth',
})
-- Vim-fugitive
MiniDeps.add({
  source = 'tpope/vim-fugitive',
})
-- Colorscheme
MiniDeps.add({
  source = 'rose-pine/neovim',
})
vim.cmd[[colorscheme rose-pine]]
-- Undotree
MiniDeps.add({
  source = 'mbbill/undotree',
})
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
-- Fterm
MiniDeps.add({
  source = 'numToStr/FTerm.nvim',
})
vim.keymap.set('n', '<C-_>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<C-_>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
-- vim-asciidoctor
MiniDeps.add({
  source = 'habamax/vim-asciidoctor',
})

vim.api.nvim_set_keymap('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { noremap = true, expr = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { noremap = true, expr = true })
local keys = {
  ['cr']        = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
  ['ctrl-y']    = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
  ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
}

_G.cr_action = function()
  if vim.fn.pumvisible() ~= 0 then
    -- If popup is visible, confirm selected item or add new line otherwise
    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    return item_selected and keys['ctrl-y'] or keys['ctrl-y_cr']
  else
    -- If popup is not visible, use plain `<CR>`. You might want to customize
    -- according to other plugins. For example, to use 'mini.pairs', replace
    -- next line with `return require('mini.pairs').cr()`
    return keys['cr']
  end
end

vim.api.nvim_set_keymap('i', '<CR>', 'v:lua._G.cr_action()', { noremap = true, expr = true })
