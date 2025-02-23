return { -- multicursor: all editors need one
'jake-stewart/multicursor.nvim',
	event = 'InsertEnter',
	config = function()

		local map = vim.keymap.set
		map('n', '<M-down>', function() require('multicursor-nvim').lineAddCursor(1) end, {desc = "Add cursor below"})
		map('n', '<M-up>', function() require('multicursor-nvim').lineAddCursor(-1) end, {desc = "Add cursor above"})
		map({'n', 'x'}, '<M-left>', require('multicursor-nvim').prevCursor, {desc = "Go previous cursor"})
		map({'n', 'x'}, '<M-right>', require('multicursor-nvim').nextCursor, {desc = "Go next cursor"})
		map({'n', 'x'}, '<M-x>', require('multicursor-nvim').deleteCursor, {desc = "Delete Cursor"})

		map({'n', 'v'}, '<M-n>', function() require('multicursor-nvim').matchAddCursor(1) end, {desc = "Add new cursor matching word/selection"})
		map({'n', 'v'}, '<M-N>', function() require('multicursor-nvim').matchAllAddCursors() end, {desc = "Add all cursors matching word/selection"})

		local mc = require("multicursor-nvim")
		mc.setup()
		map("n", "<esc>", function()
			if not mc.cursorsEnabled() then
				mc.enableCursors()
			elseif mc.hasCursors() then
				mc.clearCursors()
			else
				vim.cmd("nohlsearch")
			end
		end)
	end,
}
