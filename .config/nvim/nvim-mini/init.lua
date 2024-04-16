-- set leader
vim.g.mapleader = ' '

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

-- [[ options ]]
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- copy & paste mapping to clipboard using leader
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y')
vim.keymap.set('n', '<leader>p', '"+p')
vim.keymap.set('n', '<leader>P', '"+P')

-- hotkeys quickfix
vim.keymap.set('n', '[q', '<cmd>cprev<CR>zz')
vim.keymap.set('n', ']q', '<cmd>cnext<CR>zz')

vim.opt.termguicolors = true

-- find files & live_grep
vim.keymap.set('n', '<leader>pf', function() MiniPick.builtin.files() end)
vim.keymap.set('n', '<C-p>', function() MiniPick.builtin.git() end)
vim.keymap.set('n', '<leader>pg', function() MiniPick.builtin.grep_live() end)
vim.keymap.set('n', '<leader>sh', function() MiniPick.builtin.help() end)
vim.keymap.set('n', '<leader>ds', function() MiniExtra.pickers.lsp({scope = 'document_symbol'}) end)
vim.keymap.set('n', '<leader>ps', function() MiniExtra.pickers.lsp({scope = 'workspace_symbol'}) end)

-- [[ plugins ]]
-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })
require('mini.clue').setup()
require('mini.completion').setup()
require('mini.pick').setup({mappings = { choose_marked = '<C-q>', mark_all = '<C-e>'}})
require('mini.statusline').setup()
require('mini.extra').setup()

MiniDeps.add({
  source = 'neovim/nvim-lspconfig',
  -- Supply dependencies near target plugin
  depends = { 'williamboman/mason.nvim' },
})


local lspconfig = require('lspconfig')
lspconfig.clangd.setup {}

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    --vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
    --vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>dca', vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>df', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

MiniDeps.add({
  source = 'lifepillar/vim-gruvbox8',
})
--vim.cmd [[colorscheme gruvbox8]]

MiniDeps.add({
  source = 'aktersnurra/no-clown-fiesta.nvim',

})
vim.cmd [[colorscheme no-clown-fiesta]]

MiniDeps.add({
  source = 'folke/tokyonight.nvim',
})
--vim.cmd [[colorscheme tokyonight]]

-- Asyncdo
MiniDeps.add({
  source = 'hauleth/asyncdo.vim',
})

