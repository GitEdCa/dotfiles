--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Setting options ]]
vim.opt.mouse = 'a'
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
-- Enable break indent
vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile   = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase  = true
-- Keep signcolumn on by default
-- vim.opt.signcolumn = 'yes'
-- Decrease update time
vim.opt.updatetime = 250
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
-- colorscheme
vim.cmd.colorscheme('habamax')

-- [[ Basic keymaps ]]
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', "[d", vim.diagnostic.goto_next, { desc = 'Go next Diagnostic'} )
vim.keymap.set('n', "]d", vim.diagnostic.goto_prev, { desc = 'Go prev Diagnostic' } )
-- escape hotkeys
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, desc = "Escape to normal mode"})
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- save with C-s
vim.keymap.set({'x', 'n', 'i'}, '<C-s>', '<Esc><cmd>up<CR><ESC>', { desc = "Save current file"})
-- yank behaviour like D or C
vim.keymap.set('n', 'Y', 'y$', { desc = "Yank behaviour like D or C"})


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
		{ --lsp
				"neovim/nvim-lspconfig",
				dependencies = {
						"williamboman/mason.nvim",
						"williamboman/mason-lspconfig.nvim",
						"hrsh7th/cmp-nvim-lsp",
						"hrsh7th/cmp-buffer",
						"hrsh7th/cmp-path",
						"hrsh7th/cmp-cmdline",
						"hrsh7th/nvim-cmp",
						"saadparwaiz1/cmp_luasnip",
						"j-hui/fidget.nvim",
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
						local capabilities = vim.tbl_deep_extend(
								"force",
								{},
								vim.lsp.protocol.make_client_capabilities(),
								cmp_lsp.default_capabilities())

								require("fidget").setup({})
								require("mason").setup()
								require("mason-lspconfig").setup({
										ensure_installed = {
												"lua_ls",
												"rust_analyzer",
												-- "clangd",
												"pyright",
										},
										handlers = {
												function(server_name) -- default handler (optional)
														require("lspconfig")[server_name].setup {
																capabilities = capabilities
														}
												end,
												["lua_ls"] = function()
														local lspconfig = require("lspconfig")
														lspconfig.lua_ls.setup {
																capabilities = capabilities,
																settings = {
																		Lua = {
																				diagnostics = {
																						globals = { "vim", "it", "describe", "before_each", "after_each" },
																				}
																		}
																}
														}
												end,
										}
								})

								vim.api.nvim_create_autocmd('LspAttach', {
										group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
										callback = function(event)
												local map = function(keys, func, desc)
														vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
												end
												map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
												map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
												map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
												map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
												map('<leader>s', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
												map('<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
												map('<leader>r', vim.lsp.buf.rename, '[R]e[n]ame')
												map('<leader>a', vim.lsp.buf.code_action, '[C]ode [A]ction')
												map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
												vim.keymap.set("i", "<C-k>", function() vim.lsp.buf.signature_help() end)
												map("<C-k>", vim.diagnostic.open_float, 'Show error line')

												local client = vim.lsp.get_client_by_id(event.data.client_id)
												if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
														local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
														vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
																buffer = event.buf,
																group = highlight_augroup,
																callback = vim.lsp.buf.document_highlight,
														})

														vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
																buffer = event.buf,
																group = highlight_augroup,
																callback = vim.lsp.buf.clear_references,
														})

														vim.api.nvim_create_autocmd('LspDetach', {
																group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
																callback = function(event2)
																		vim.lsp.buf.clear_references()
																		vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
																end,
														})
												end
												if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
														map('<leader>th', function()
																vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
														end, '[T]oggle Inlay [H]ints')
												end
										end,
								})

								local cmp_select = { behavior = cmp.SelectBehavior.Select }

								cmp.setup({
										snippet = {
												expand = function(args)
														require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
												end,
										},
										mapping = cmp.mapping.preset.insert({
												-- ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
												-- ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
												-- ['<C-y>'] = cmp.mapping.confirm({ select = true }),
												["<C-Space>"] = cmp.mapping.complete(),
												['<CR>'] = cmp.mapping.confirm { select = true },
												['<Tab>'] = cmp.mapping.select_next_item(),
												['<S-Tab>'] = cmp.mapping.select_prev_item(),
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
										}),
										sources = cmp.config.sources({
												{ name = 'nvim_lsp' },
												{ name = 'luasnip' }, -- For luasnip users.
										}, {
												{ name = 'buffer' },
												{ name = 'path' },
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
						end
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
      vim.keymap.set('n', '<leader>g', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>G', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>.', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = '[/] Fuzzily search in current buffer' })
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
        enable = true,
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
		  vim.g.slime_target = 'neovim'
	  end,
  },

	{
		'maxbrunsfeld/vim-yankstack',
		event = 'VeryLazy',
	},

})
