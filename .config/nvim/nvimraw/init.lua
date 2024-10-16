-- [[ Setting options ]]
vim.g.mapleader = ' '
vim.opt.mouse = 'a'
-- copy to system clipboard by default
vim.schedule(function()
	vim.opt.clipboard = 'unnamedplus'
end)
-- enable icons
vim.g.have_nerd_font = true
-- Enable break indent
vim.opt.breakindent    = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
-- Keep signcolumn on by default
vim.opt.signcolumn     = 'yes'
-- Decrease update time
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

vim.opt.guicursor      = ""
vim.opt.nu             = true
vim.opt.relativenumber = true
vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.smartindent    = true
vim.opt.wrap           = false
vim.opt.swapfile       = false
vim.opt.backup         = false
-- Save undo history
vim.opt.undodir        = os.getenv("HOME") .. "/.undodir"
vim.opt.undofile       = true
vim.opt.hlsearch       = false
vim.opt.incsearch      = true
vim.opt.termguicolors  = true
vim.opt.signcolumn     = "yes"
vim.opt.colorcolumn    = "80"

-- [[ Basic keymaps ]]
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
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

-- [[ Basic Autocommands ]]
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
  augroup END
]]
-- linting
vim.cmd [[
  augroup Linting
	  autocmd!
	  autocmd FileType rust setlocal makeprg=cargo\ build
	  autocmd FileType c,cpp setlocal makeprg=xmake
	  autocmd FileType c,cpp setlocal efm=%.%#:\ %f:%l:%c:\ %m
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
-- [[ Configure and install plugins ]]
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  {
    'tpope/vim-sleuth',
  },

  {
    'tpope/vim-fugitive',
    cmd = 'Git',
  },

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

  { -- colorscheme
    'Mofiqul/dracula.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme('dracula')
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      require('mini.indentscope').setup {}
      require('mini.pairs').setup {}
      require('mini.bracketed').setup {}
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = false }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
	return '%2l:%-2v'
      end

      require('mini.files').setup()
      vim.keymap.set('n', '<leader>e', function() MiniFiles.open() end)
      vim.keymap.set('n', '<leader>E', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)
      end
    },

    { -- Fuzzy Finder (files, lsp, etc)
      'nvim-telescope/telescope.nvim',
      event = 'VimEnter',
      branch = '0.1.x',
      dependencies = {
	'nvim-lua/plenary.nvim',
      },
      config = function()
	require('telescope').setup()

	-- See `:help telescope.builtin`
	local builtin = require 'telescope.builtin'
	vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = '[S]earch [H]elp' })
	vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = '[S]earch [F]iles' })
	vim.keymap.set('n', '<leader>,', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
	vim.keymap.set('n', '<leader>G', builtin.live_grep, { desc = '[S]earch by [G]rep' })
	vim.keymap.set('n', '<leader>g', builtin.grep_string, { desc = 'Search current word' })
	vim.keymap.set('n', '<leader>.', builtin.resume, { desc = '[S]earch [R]esume' })
	vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
	vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
      end,
    },

    {
      'jpalardy/vim-slime',
      init = function()
	vim.g.slime_target = 'tmux'
	vim.g.slime_no_mappings = 1
	vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
	vim.g.slime_dont_ask_default = 1
      end,
      config = function()
	vim.keymap.set({ 'n', 'x' }, '<M-cr>', '<Plug>SlimeParagraphSend')
      end
    },

    {
      'maxbrunsfeld/vim-yankstack',
      event = 'VeryLazy',
    },

    { -- expand
      'gorkunov/smartpairs.vim',
      event = 'VeryLazy',
    },

    {
      'mbbill/undotree',
      keys = {
	{ '<leader>u', vim.cmd.UndotreeToggle }
      },
    },

    {
      'hauleth/asyncdo.vim',
      event = 'VeryLazy',
    },

})

local rlbook = require('rlbook')
vim.keymap.set('n', '<leader>1', function() rlbook.save_bookmark(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>2', function() rlbook.save_bookmark(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>3', function() rlbook.save_bookmark(3) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-1>', function() rlbook.goto_bookmark(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-2>', function() rlbook.goto_bookmark(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-3>', function() rlbook.goto_bookmark(3) end, { noremap = true, silent = true })

