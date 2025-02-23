return { -- guess-indent: Automatically set indent values
	'NMAC427/guess-indent.nvim',
	event = 'BufEnter',
	opts = {
		override_editorconfig = true
	},
}
