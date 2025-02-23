return { -- Highlight, edit, and navigate code
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	event = 'InsertEnter',
	main = 'nvim-treesitter.configs', -- Sets main module to use for opts
	opts = {
		ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'vim', 'vimdoc', 'java', 'rust' },
		-- Autoinstall languages that are not installed
		auto_install = true,
		highlight = { enable = true, },
		indent = { enable = true },
	},
	config = function()
		require'nvim-treesitter.configs'.setup {
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<M-o>",
					scope_incremental = "<M-O>",
					node_incremental = "<M-o>",
					node_decremental = "<M-i>",
				},
			},
		}
	end,
}
