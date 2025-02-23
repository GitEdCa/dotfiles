return { -- nvim-cmp: Autocomplete
			'hrsh7th/nvim-cmp',
			event = 'InsertEnter',
			dependencies = {
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
				'saadparwaiz1/cmp_luasnip',
				'rafamadriz/friendly-snippets',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-path',
			},
			config = function()
				local cmp = require 'cmp'
				cmp.setup({
					sources = {
						{name = 'path'},
						{name = 'nvim_lsp'},
						{name = 'luasnip', keyword_length = 2},
						{name = 'buffer', keyword_length = 3},
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					snippet = {
						expand = function(args)
							require('luasnip').lsp_expand(args.body)
						end,
					},
					completion = { completeopt = 'menu,menuone,noinsert,noselect' }, 
					mapping = cmp.mapping.preset.insert({
						['<C-n>'] = cmp.mapping.select_next_item(),
						['<C-p>'] = cmp.mapping.select_prev_item(),
						['<C-y>'] = cmp.mapping.confirm { select = true },
						['<CR>'] = cmp.mapping.confirm { select = true },
						-- ['<Tab>'] = cmp.mapping.select_next_item(),
						--['<S-Tab>'] = cmp.mapping.select_prev_item(),
						['<C-Space>'] = cmp.mapping.complete {},
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
					})
				})
			end,
		}
