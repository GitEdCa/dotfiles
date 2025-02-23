return { -- Undotree: Undo UI
	'mbbill/undotree',
	cmd = 'UndotreeToggle',
	keys = {
		{ '<leader>u', vim.cmd.UndotreeToggle }
	},
}
