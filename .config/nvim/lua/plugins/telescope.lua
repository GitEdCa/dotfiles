return { -- telescope: Fuzzy finder
	'nvim-telescope/telescope.nvim',
	event = 'VimEnter',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
		},
		{ 'nvim-telescope/telescope-ui-select.nvim' },
	},
	cmd = 'Telescope',
	keys = {
		{ '<leader>f', '<cmd>Telescope find_files<CR>', desc = 'Search Files' },
		{ '<leader>,', '<cmd>Telescope builtin<CR>', desc = 'Search Picker' },
		{ '<leader>d', '<cmd>Telescope diagnostics<CR>', desc = 'Search Diagnostics' },
		{ '<leader>.', '<cmd>Telescope resume<CR>', desc = 'Search Resume'  },
		{ '<leader>b', '<cmd>Telescope buffers<CR>', desc = 'Find existing buffers' },
		{ '<leader>h', '<cmd>Telescope help_tags<CR>', desc = 'Search Help' },
		{ '<leader>/', '<cmd>Telescope live_grep<CR>', desc = 'Live Grep' },
		{ '<leader>g', function() require('telescope.builtin').grep_string({search = vim.fn.input('Grep > ')}) end, desc = 'Grep' },
		{ '<leader>l', '<cmd>Telescope current_buffer_fuzzy_find<CR>', desc = 'Current Buffer lines' },
		{ '<leader>c', function() require('telescope.builtin').find_files({cwd = vim.fn.stdpath('config')}) end, desc = 'Find Neovim Files' },
	},
	opts = {},
}
