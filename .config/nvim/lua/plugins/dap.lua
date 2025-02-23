return { -- nvim-dap: Debugging
	'mfussenegger/nvim-dap',
	dependencies = {
		'rcarriga/nvim-dap-ui',
		'nvim-neotest/nvim-nio',
		'williamboman/mason.nvim',
	},
	keys = {
		-- Basic debugging keymaps, feel free to change to your liking!
		{ '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
		{ '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
		{ '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
		{ '<F12>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
		{ '<F9>', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
		{ '<S-F9>', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Breakpoint' },
		-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
		{ '<F8>', function() require('dapui').toggle() end, desc = 'Debug: See last session result.'},
	},
	config = function()
		local dap = require 'dap'
		local dapui = require 'dapui'

		-- Dap UI setup
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

		-- adapter & config c++
		local dap = require("dap")
		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
		}
		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				-- program = "${file}",
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			}
		}
		end,
}
