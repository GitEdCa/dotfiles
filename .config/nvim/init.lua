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

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Automatically remove ending spaces when saving buffer",
	group = vim.api.nvim_create_augroup("theprimegeangroup", { clear = true }),
	pattern = "*",
	command = [[%s/\s\+$//e]],
})

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

	{ "catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		init = function()
			vim.cmd.colorscheme('catppuccin')
		end,
	},
	-- {          --schema
	-- 	'Mofiqul/dracula.nvim',
	-- 	priority = 1000, -- Make sure to load this before all the other start plugins.
	-- 	init = function()
	-- 		vim.cmd.colorscheme('dracula')
	-- 		vim.cmd.hi 'Comment gui=none'
	-- 	end,
	-- },


	{ --lsp
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/nvim-cmp",
			"saadparwaiz1/cmp_luasnip",
			{
				'L3MON4D3/LuaSnip',
				build = (function()
					if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
						return
					end
					return 'make install_jsregexp'
				end)(),
				dependencies = {
					{
						'rafamadriz/friendly-snippets',
						config = function()
							require('luasnip.loaders.from_vscode').lazy_load()
						end,
					},
				},
			},
		},
		config = function()
			local cmp = require('cmp')
			local cmp_lsp = require("cmp_nvim_lsp")
			require("mason").setup()
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim", "it", "describe", "before_each", "after_each" },
							}
						}
					}
				},
				rust_analyzer = {
					filetypes = {"rust"},
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
			local capabilities = vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities())
			for server, settings in pairs(servers) do
				settings.capabilities = capabilities
				require("lspconfig")[server].setup(settings)
			end

			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set('n', keys, func,
							{ buffer = event.buf, desc = 'LSP: ' .. desc })
					end
					local opts = { buffer = bufnr }
					map('K', vim.lsp.buf.hover, 'SHow info over cursor')
					map('gd', vim.lsp.buf.definition, 'Go to definition')
					map('gD', vim.lsp.buf.declaration, 'Go to Declarations')
					map('gi', vim.lsp.buf.implementation, 'Go to Implementations')
					map('go', vim.lsp.buf.type_definition, 'Go to Type Definitions')
					map('gr', vim.lsp.buf.references, 'Go to References')
					map('gs', vim.lsp.buf.signature_help, 'Show Signature Help')
					map('<F2>', vim.lsp.buf.rename, 'Rename')
					vim.keymap.set({ 'n', 'x' }, '<F3>',
						'<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
					map('<F4>', vim.lsp.buf.code_action, 'Open code actions')
					map("<C-k>", vim.diagnostic.open_float, 'Show error line')

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map('<leader>th', function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
						end, '[T]oggle Inlay [H]ints')
					end
				end,
			})

			local luasnip = require 'luasnip'
			luasnip.config.setup {}

			vim.o.completeopt = "menuone,noselect,preview"
			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				preselect = cmp.PreselectMode.None,
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
						s = cmp.mapping.confirm({ select = false }),
						c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),

					}),
					['<Tab>'] = cmp.mapping.select_next_item(),
					['<S-Tab>'] = cmp.mapping.select_prev_item(),
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
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' }, -- For luasnip users.
				}, {
					{ name = 'buffer' },
					{ name = 'path' },
					{ name = "hrsh7th/cmp-cmdline" }
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
		end,
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
			vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find,
				{ desc = '[/] Fuzzily search in current buffer' })
		end,
	},

	{ -- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		opts = {
			ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'java', 'python' },
			auto_install = false,
			highlight = {
				enable = true,
			},
			indent = { enable = true },
			incremental_selection = {
				enable = false,
				keymaps = {
					node_incremental = "v",
					node_decremental = "V",
				},
			},
		},
		config = function(_, opts)
			require('nvim-treesitter.configs').setup(opts)
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

	{ -- Collection of various small independent plugins/modules
		'echasnovski/mini.nvim',
		config = function()
			require('mini.indentscope').setup {}
			require('mini.pairs').setup {}
			require('mini.bracketed').setup {}
			require('mini.surround').setup()
			require('mini.files').setup()
			local statusline = require 'mini.statusline'
			statusline.setup { use_icons = vim.g.have_nerd_font }
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return '%2l:%-2v'
			end
			-- keymaps mini plugins
			vim.keymap.set('n', '<leader>e', function() MiniFiles.open() end)
			vim.keymap.set('n', '<leader>E', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)

		end,
	},

	{
		'mbbill/undotree',
		keys = {
			{ '<leader>u', vim.cmd.UndotreeToggle }
		},
	},

	{ -- dap
		'mfussenegger/nvim-dap',
		dependencies = {
			'rcarriga/nvim-dap-ui',
			'nvim-neotest/nvim-nio',
			'williamboman/mason.nvim',
		},
		keys = function(_, keys)
			local dap = require 'dap'
			local dapui = require 'dapui'
			return {
				-- Basic debugging keymaps, feel free to change to your liking!
				{ '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
				{ '<F6>', dap.step_into, desc = 'Debug: Step Into' },
				{ '<F7>', dap.step_out, desc = 'Debug: Step Out' },
				{ '<F8>', dap.step_over, desc = 'Debug: Step Over' },
				{ '<F9>', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
				{
					'<S-F9>',
					function()
						dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
					end,
					desc = 'Debug: Set Breakpoint',
				},
				-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
				{ '<S-F5>', dapui.toggle, desc = 'Debug: See last session result.' },
				unpack(keys),
			}
		end,
		config = function()
			local dap = require 'dap'
			local dapui = require 'dapui'

			dapui.setup {
				icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
				controls = {
					icons = {
						pause = '⏸',
						play = '▶',
						step_into = '⏎',
						step_over = '⏭',
						step_out = '⏮',
						step_back = 'b',
						run_last = '▶▶',
						terminate = '⏹',
						disconnect = '⏏',
					},
				},
			}
			dap.listeners.after.event_initialized['dapui_config'] = dapui.open
			dap.listeners.before.event_terminated['dapui_config'] = dapui.close
			dap.listeners.before.event_exited['dapui_config'] = dapui.close

			-- rust config
			dap.adapters.gdb = {
				type = "executable",
				command = "rust-gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
			}
			dap.configurations.rust = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = function()
						return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
					end,
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
			}
		end,
	}
})
