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
-- Save undo history
vim.opt.undofile       = true
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
vim.opt.undodir        = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.hlsearch       = false
vim.opt.incsearch      = true
vim.opt.termguicolors  = true
vim.opt.signcolumn     = "yes"
vim.opt.colorcolumn    = "80"
-- colorscheme
-- vim.cmd.colorscheme('habamax')

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
vim.keymap.set("n", ";", ":")
-- suggestions by ins-completion
vim.keymap.set('i', '<C-]>', '<C-x><C-]>', { noremap = true } )
vim.keymap.set('i', '<C-f>', '<C-x><C-f>', { noremap = true } )
vim.keymap.set('i', '<C-d>', '<C-x><C-d>', { noremap = true } )
vim.keymap.set('i', '<C-l>', '<C-x><C-l>', { noremap = true } )
-- duplicate current line and preserved cursor position
vim.keymap.set({ 'n', 'i' } , '<A-t>', '<cmd>:t.<CR>')

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

-- [[ Plugins ]]
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

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

-- Define helpers
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Mini.nvim =================
add({ name = 'mini.nvim', checkout = 'HEAD' })

now(function()
	local statusline = require 'mini.statusline'
	statusline.setup { use_icons = vim.g.have_nerd_font }
	---@diagnostic disable-next-line: duplicate-set-field
	statusline.section_location = function()
		return '%2l:%-2v'
	end
end)

later(function () require('mini.indentscope').setup() end)
later(function () require('mini.pairs').setup() end)
later(function () require('mini.bracketed').setup() end)
later(function () require('mini.surround').setup() end)

later(function () require('mini.completion').setup()
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

  vim.keymap.set('i', '<CR>', 'v:lua._G.cr_action()', { expr = true })
end)

later(function () require('mini.files').setup()
  vim.keymap.set('n', '<leader>e', function() MiniFiles.open() end)
  vim.keymap.set('n', '<leader>E', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)
end)

later(function () require('mini.files').setup()
  vim.keymap.set('n', '<leader>e', function() MiniFiles.open() end)
  vim.keymap.set('n', '<leader>E', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)
end)

later(function () require('mini.pick').setup()
  vim.keymap.set('n', '<leader>f', function() MiniPick.builtin.files() end)
  vim.keymap.set('n', '<leader>F', function() MiniPick.builtin.git() end)
  vim.keymap.set('n', '<leader>g', function() MiniPick.builtin.grep() end)
  vim.keymap.set('n', '<leader>G', function() MiniPick.builtin.grep_live() end)
  vim.keymap.set('n', '<leader>h', function() MiniPick.builtin.help() end)
  vim.keymap.set('n', '<leader>,', function() MiniPick.builtin.resume() end)
  vim.keymap.set('n', '<leader><leader>', function() MiniPick.builtin.buffers() end)

end)

later(function () require('mini.extra').setup()
  vim.keymap.set('n', '<leader>/', function() MiniExtra.pickers.buf_lines() end)

  local pickers = {}
  local pickers_names = {}
  local run_picker = function(name) 
    local f = pickers[name]
    f()
  end

  local builtin = MiniPick.builtin
  local extra   = MiniExtra.pickers
  for k, v in pairs(builtin) do
    table.insert(pickers_names, k)
    pickers[k] = v
  end

  for k, v in pairs(extra) do
    table.insert(pickers_names, k)
    pickers[k] = v
  end

  local builtinPickers = function()
    MiniPick.start({
      source = {
	items = pickers_names,
	choose = run_picker,
      },
    })
  end
  vim.keymap.set('n', '<leader>,', builtinPickers)
end)

-- other plugins ==========================================================
now(function()
  add('catppuccin/nvim')
  vim.cmd.colorscheme('catppuccin')
end)

later(function() add('tpope/vim-sleuth') end)
later(function() add('tpope/vim-fugitive') end)

later(function() add('lewis6991/gitsigns.nvim') end)

later(function()
  add('jpalardy/vim-slime')
  vim.g.slime_target = 'tmux'
  vim.g.slime_no_mappings = 1
  vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
  vim.g.slime_dont_ask_default = 1
  vim.keymap.set({ 'n', 'x' }, '<M-cr>', '<Plug>SlimeParagraphSend')
end)

later(function()
  add('mbbill/undotree')
  vim.keymap.set('n', '<leader>u', vim.cmd.MundoToggle)
end)

later(function()
  add('pechorin/any-jump.vim')
  vim.keymap.set('n', '<leader>j', vim.cmd.AnyJump)
  vim.g.any_jump_disable_default_keybindings = 1
end)

later(function() add('maxbrunsfeld/vim-yankstack') end)

later(function ()
  add({
    source ='nvim-treesitter/nvim-treesitter',
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  require('nvim-treesitter.configs').setup({
	  highlight = { enable = true },
	  ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'java', 'python' },
	  auto_install = false,
	  indent = { enable = true },
	  incremental_selection = {
		  enable = false,
		  keymaps = {
			  node_incremental = "v",
			  node_decremental = "V",
		  },
	  },
  })
  add({source = 'nvim-treesitter/nvim-treesitter-context'})
  require'treesitter-context'.setup{ max_lines = 2}
end)

local rlbook = require('rlbook')
vim.keymap.set('n', '<leader>1', function() rlbook.save_bookmark(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>2', function() rlbook.save_bookmark(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>3', function() rlbook.save_bookmark(3) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-1>', function() rlbook.goto_bookmark(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-2>', function() rlbook.goto_bookmark(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<A-3>', function() rlbook.goto_bookmark(3) end, { noremap = true, silent = true })
