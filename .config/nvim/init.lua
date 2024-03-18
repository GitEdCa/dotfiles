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
	"rose-pine/neovim",
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
			require('mini.bracketed').setup()
			require('mini.pairs').setup()
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
		keys = {
			{ '<leader>o', '<cmd>Tags<CR>' },
			{ '<leader>;', '<cmd>History:<CR>' },
			{ '<C-p>', '<cmd>GFiles<CR>' },
			{ '<leader>f', '<cmd>Files<CR>' },
			{ '<leader>r', '<cmd>Rg<CR>' },
			{ '<leader>b', '<cmd>Buffers<CR>' },
		},
	},
	{
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-context'
		},
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
			{ '<leader>a', '<cmd>lua require("neomarks").mark_file()<CR>' },
			{ '<C-e>', '<cmd>lua require("neomarks").menu_toggle()<CR>' },
		},
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		'williamboman/mason.nvim',
		lazy = false,
		config = true,
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{'L3MON4D3/LuaSnip'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_cmp()

			-- And you can configure cmp even more, if you want to.
			local cmp = require('cmp')
			local cmp_action = lsp_zero.cmp_action()

			local luasnip = require('luasnip')

			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				sources = {
					{name = 'path'},
					{name = 'nvim_lsp'},
					{name = 'luasnip', keyword_length = 2},
					{name = 'buffer', keyword_length = 3},
				},
				formatting = lsp_zero.cmp_format({details = true}),
				mapping = cmp.mapping.preset.insert({
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					['<C-Space>'] = cmp.mapping.complete(),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							--cmp.select_next_item()
							cmp.confirm({select = true})
								-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
								-- that way you will only jump inside the snippet region
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
						end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
						end, { "i", "s" }),

				}),
			})
		end,
	},

	-- LSP
	{
		'neovim/nvim-lspconfig',
		cmd = {'LspInfo', 'LspInstall', 'LspStart'},
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
			{'williamboman/mason-lspconfig.nvim'},
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_lspconfig()

			--- if you want to know more about lsp-zero and mason.nvim
			--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
			lsp_zero.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({buffer = bufnr})
			end)
			require('lspconfig').clangd.setup({})

			require('mason-lspconfig').setup({
				ensure_installed = {},
				handlers = {
					lsp_zero.default_setup,
					lua_ls = function()
						-- (Optional) Configure lua language server for neovim
						local lua_opts = lsp_zero.nvim_lua_ls()
						require('lspconfig').lua_ls.setup(lua_opts)
					end,
				}
			})
		end
	},
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
--vim.cmd[[colorscheme no-clown-fiesta]] -- theme
vim.cmd("colorscheme rose-pine") -- theme

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
-- Open explorer
vim.keymap.set('n', '<leader>e', ":Vex<CR>", {})
