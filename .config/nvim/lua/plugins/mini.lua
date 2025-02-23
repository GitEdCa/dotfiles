return { -- mini.nvim: lot of core functionality
	'echasnovski/mini.nvim',
	config = function()

		require('mini.ai').setup()         -- a/i textobjects
		require('mini.align').setup()      -- aligning
		require('mini.bracketed').setup()  -- unimpaired bindings with TS
		require('mini.comment').setup()    -- TS-wise comments
		require('mini.icons').setup()      -- minimal icons
		require('mini.jump').setup()       -- fFtT work past a line
		require('mini.pairs').setup()      -- pair brackets
		local statusline = require 'mini.statusline' -- status line
		statusline.setup { use_icons = true }
		statusline.section_location = function()
			return '%2l:%-2v'
		end
		require('mini.jump2d').setup()     -- jump to another word

		require('mini.surround').setup({   -- surround
			custom_surroundings = {
				['l'] = { output = { left = '[', right = ']()'}}
			}
		})
		local miniclue = require('mini.clue')
		miniclue.setup({  -- cute prompts about bindings
			triggers = {
				{ mode = 'n', keys = '<Leader>' },
				{ mode = 'x', keys = '<Leader>' },
				{ mode = 'n', keys = '<space>' },
				{ mode = 'x', keys = '<space>' },

				-- Built-in completion
				{ mode = 'i', keys = '<C-x>' },

				-- `g` key
				{ mode = 'n', keys = 'g' },
				{ mode = 'x', keys = 'g' },

				-- Marks
				{ mode = 'n', keys = "'" },
				{ mode = 'n', keys = '`' },
				{ mode = 'x', keys = "'" },
				{ mode = 'x', keys = '`' },

				-- Registers
				{ mode = 'n', keys = '"' },
				{ mode = 'x', keys = '"' },
				{ mode = 'i', keys = '<C-r>' },
				{ mode = 'c', keys = '<C-r>' },

				-- Window commands
				{ mode = 'n', keys = '<C-w>' },

				-- `z` key
				{ mode = 'n', keys = 'z' },
				{ mode = 'x', keys = 'z' },

				-- Bracketed
				{ mode = 'n', keys = '[' },
				{ mode = 'n', keys = ']' },
			},
			clues = {
				miniclue.gen_clues.builtin_completion(),
				miniclue.gen_clues.g(),
				miniclue.gen_clues.marks(),
				miniclue.gen_clues.registers(),
				miniclue.gen_clues.windows(),
				miniclue.gen_clues.z(),
			},
		})
	end,
}
