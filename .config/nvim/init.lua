-- lazy.nvim
--
vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	"aktersnurra/no-clown-fiesta.nvim",
	{
		'numToStr/FTerm.nvim',
		keys = {
			{ '<leader>t', '<CMD>lua require("FTerm").toggle()<CR>' },
			{ '<leader>t', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', mode= "t", }
		}
	},

	{
		'echasnovski/mini.nvim',
		event = "VeryLazy",
		config = function()
			require('mini.completion').setup()
			require('mini.bracketed').setup()
			require('mini.pairs').setup()
			require('mini.files').setup()


			vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
			vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

			local keys = {
				['cr']        = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
				['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
			}

			_G.cr_action = function()
				if vim.fn.pumvisible() ~= 0 then
					-- If popup is visible, confirm selected item or add new line otherwise
					local item_selected = vim.fn.complete_info()['selected'] ~= -1
					return keys['ctrl-y_cr']
				else
					-- If popup is not visible, use plain `<CR>`. You might want to customize
					-- according to other plugins. For example, to use 'mini.pairs', replace
					-- next line with `return require('mini.pairs').cr()`
					return keys['cr']
				end
			end
		end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
		},
	},

	{
		'junegunn/fzf',
		dependencies = {
			'junegunn/fzf.vim'
		},
		--vim.g['fzf_action'] = {['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit'}
		--vim.g['fzf_layout'] = {window = {width = 0.8, height = 0.8}}
		--vim.g['fzf_preview_window'] = {'up:50%:+{2}-/2', 'ctrl-/'}
		keys = {
			{ '<leader>o', '<cmd>Tags<CR>' },
			{ '<leader>;', '<cmd>History:<CR>' },
			{ '<leader>f', '<cmd>Files<CR>' },
			{ '<leader>r', '<cmd>Rg<CR>' },
			{ '<leader>b', '<cmd>Buffers<CR>' },
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local nvim_lsp = require("lspconfig")
			nvim_lsp.clangd.setup{}
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter',
		build = ":TSUpdate",
		event = "VeryLazy",
		config = function () 
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "cpp", "rust", "javascript", "html" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },  
			})
		end

	},
	{
		'saccarosium/neomarks',
		keys = {
			{ '<leader>m', '<cmd>lua require("neomarks").mark_file()<CR>' },
			{ '<leader>m', '<cmd>lua require("neomarks").menu_toggle()<CR>' },
		},
	}
})

vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = false
vim.opt.wrap = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
vim.opt.undofile = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.cmd[[colorscheme no-clown-fiesta]] -- theme

--
-- linting
--
--vim.cmd[[autocmd QuickFixCmdPost [^l]* nested cwindow]]
--vim.cmd[[autocmd QuickFixCmdPost    l* nested lwindow]]

--
-- Mappings
--
vim.g.mapleader = " "
-- copy and paste to system clipboard
vim.keymap.set({"n", "v"}, "gy", "\"+y")
vim.keymap.set({"n", "v"}, "gY", "\"+Y")
vim.keymap.set("n", "gp", "\"+p")
vim.keymap.set("n", "gP", "\"+P")
-- n and N always the same direction
local expr = {silent = true, expr = true, remap = false}
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", expr)
vim.keymap.set("n", "N", "'nN'[v:searchforward]", expr)
--changing word and keep word in / register
vim.keymap.set("n", "cn", "*``cgn")
--indent recent pasted code
vim.keymap.set("n", "<leader>=", "`[v`]=")
-- apply formatter
--vim.keymap.set("n", "<F10>", ":%!clang-format<CR>2g;")
vim.keymap.set("n", "<F10>", "gggqG2g;")
-- run make
vim.keymap.set("n", "<F9>", ":w<CR> :Make<CR>")
-- alt keys for swaping buffers
vim.keymap.set({"t","n"}, "<A-1>", "<C-\\><C-n>:1wincmd w<CR>", {silent = true})
vim.keymap.set({"t","n"}, "<A-2>", "<C-\\><C-n>:2wincmd w<CR>", {silent = true})
vim.keymap.set({"t","n"}, "<A-3>", "<C-\\><C-n>:3wincmd w<CR>", {silent = true})
-- esc in Terminal mode to return in normal mode
vim.keymap.set('t', '<Esc>', "<C-\\><C-n>", {})
-- save file and return normal mode
vim.keymap.set({"n", 'i'}, '<C-s>', "<Esc>:w<Cr>", {})
-- change last buffer
vim.keymap.set('n', '<BS>', ":b#<CR>", {})
--open cmd history
vim.keymap.set('n', '<C-f>', "q:", {})
--Clear higlighting
vim.keymap.set('n', '\\', ":nohl<CR>", {})
