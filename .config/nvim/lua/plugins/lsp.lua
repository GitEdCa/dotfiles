return { -- lspconfig: Configurations for lsp
	'neovim/nvim-lspconfig',
	dependencies = {
		{ 'williamboman/mason.nvim', opts = {} },
	},
	'hrsh7th/cmp-nvim-lsp',
	config = function()

		local map = vim.keymap.set
		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'LSP actions',
			callback = function(event)
				local opts = {buffer = event.buf}

				map('n', 'K', vim.lsp.buf.hover, opts)
				-- map('n', 'gd', vim.lsp.buf.definition, opts)
				map('n', 'gD', vim.lsp.buf.declaration, opts)
				map('n', 'gi', vim.lsp.buf.implementation, opts)
				map('n', 'go', vim.lsp.buf.type_definition, opts)
				map('n', 'gr', vim.lsp.buf.references, opts)
				map('n', 'gs', vim.lsp.buf.signature_help, opts)
				map('n', '<leader>r', vim.lsp.buf.rename, opts)
				map({'n', 'x'}, '<leader>F', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
				map('n', '<leader>a', vim.lsp.buf.code_action, opts)

				local builtin = requir('telescope.builtin')
				map('n', 'gd', builtin.lsp_definitions, opts)
				map('n', '<leader>D', builtlin.lsp_references, opts)
				map('n', '<leader>s', builtin.lsp_document_symbols, opts)
				map('n', '<leader>S', builtin.lsp_workspace_symbols, opts)
			end,
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

		-- cmp-lsp
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

		local servers = {
			-- clangd = {},
			-- jdtls = {},
			-- rust_analyzer = {},
			-- pyright = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = 'Replace',
						},
					},
				},
			},
		}

		for server, settings in pairs(servers) do
			settings.capabilities = vim.tbl_deep_extend('force', {}, capabilities, settings.capabilities or {})
			require("lspconfig")[server].setup(settings)
		end
	end,
}
