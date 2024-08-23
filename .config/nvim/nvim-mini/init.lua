-- [[ options ]]
-- set leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
-- Enable break indent
vim.opt.breakindent = true
-- Save undo history
vim.opt.undofile = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'
-- Decrease update time
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time. Displays which-key popup sooner
vim.opt.timeoutlen = 300
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
vim.opt.scrolloff = 10
-- clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- [[ Basic Keymaps ]]
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- hotkeys quickfix
vim.keymap.set('n', '[q', '<cmd>cprev<CR>zz')
vim.keymap.set('n', ']q', '<cmd>cnext<CR>zz')
-- hotkeys diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- quickckly moving between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w><C-h>', { desc = 'Move focus to the left window for terminals' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w><C-l>', { desc = 'Move focus to the right window for terminals' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w><C-j>', { desc = 'Move focus to the lower window for terminals' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w><C-k>', { desc = 'Move focus to the upper window for terminals' })
vim.keymap.set('t', '<C-^>', '<C-\\><C-n><C-6>', { desc = 'Focus to the last buffer' })
-- escape hotkeys
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, desc = "Escape to normal mode"})
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- save with C-s
vim.keymap.set({'x', 'n', 'i'}, '<C-s>', '<Esc><cmd>up<CR><ESC>', { desc = "Save current file"})

-- [[ Basic Autocommands ]]
vim.api.nvim_create_autocmd({'BufEnter', 'BufNewFile'}, {
  desc = 'Set syntax asciidoc',
  pattern = "{*.txt}",
  group = vim.api.nvim_create_augroup('set-asciidoc-syntax', { clear = true }),
  callback = function()
	  vim.cmd[[set syntax=asciidoc]]
  end,
})
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- start insert mode when moving to a terminal window
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  callback = function()
    if vim.bo.buftype == 'terminal' then vim.cmd('startinsert') end
  end,
  group = vim_term
})

-- [[ Plugins ]]
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
		{ -- Collection of various small independent plugins/modules
				'echasnovski/mini.nvim',
				config = function()
						require('mini.statusline').setup()
						require('mini.comment').setup()
						require('mini.extra').setup()
						require('mini.notify').setup()
						require('mini.cursorword').setup()
						require('mini.indentscope').setup()
						require('mini.files').setup()
						require('mini.starter').setup()
						require('mini.sessions').setup()
						require('mini.pick').setup()

						local statusline = require 'mini.statusline'
						statusline.setup {}

						---@diagnostic disable-next-line: duplicate-set-field
						statusline.section_location = function()
								return '%2l:%-2v'
						end

						vim.keymap.set('n', '<leader>E', function() MiniFiles.open() end)
						-- mini.pick
						vim.keymap.set('n', '<leader>f', function() MiniPick.builtin.files() end)
						vim.keymap.set('n', '<leader>F', function() MiniPick.builtin.git() end)
						vim.keymap.set('n', '<leader>g', function() MiniPick.builtin.grep_live() end)
						vim.keymap.set('n', '<leader>h', function() MiniPick.builtin.help() end)
						vim.keymap.set('n', '<leader>;', function() MiniPick.builtin.resume() end)
						vim.keymap.set('n', '<leader><leader>', function() MiniPick.builtin.buffers() end)
						vim.keymap.set('n', '<leader>/', function() MiniExtra.pickers.buf_lines() end)

						local set_session = function(name) MiniSessions.read(name) end
						local current_sessions = {}
						for key, _ in pairs(MiniSessions.detected) do
								table.insert(current_sessions, key)
						end
						local pick_session = function()
								print(current_sessions)
								local new_session = MiniPick.start({
										source = {
												items = current_sessions,
												choose = set_session,
										},
								})
						end
						vim.keymap.set('n', '<leader>w', pick_session, { desc = 'Pick sessions' })
				end,
		},
		{ -- Main LSP Configuration
				'neovim/nvim-lspconfig',
				dependencies = {
						-- Automatically install LSPs and related tools to stdpath for Neovim
						{ 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants

						-- Allows extra capabilities provided by nvim-cmp
						'hrsh7th/cmp-nvim-lsp',
				},
				config = function()
						vim.api.nvim_create_autocmd('LspAttach', {
								group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
								callback = function(event)
										local map = function(keys, func, desc)
												vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
										end

										map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
										-- Find references for the word under your cursor.
										map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
										-- Jump to the implementation of the word under your cursor.
										map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
										-- Jump to the type of the word under your cursor.
										map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
										-- Fuzzy find all the symbols in your current document.
										map('<leader>s', function() MiniExtra.pickers.lsp({scope = 'document_symbol'}) end, '[D]ocument [S]ymbols')
										-- Fuzzy find all the symbols in your current workspace.
										map('<leader>S', function() MiniExtra.pickers.lsp({scope = 'workspace_symbol'}) end, '[W]orkspace [S]ymbols')
										-- Rename the variable under your cursor.
										--  Most Language Servers support renaming across files, etc.
										map('<leader>r', vim.lsp.buf.rename, '[R]e[n]ame')
										-- Execute a code action, usually your cursor needs to be on top of an error
										map('<leader>.', vim.lsp.buf.code_action, '[C]ode [A]ction')
										-- This is not Goto Definition, this is Goto Declaration.
										map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

										-- When you move your cursor, the highlights will be cleared (the second autocommand).
										local client = vim.lsp.get_client_by_id(event.data.client_id)
										if client and client.server_capabilities.documentHighlightProvider then
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

										-- The following code creates a keymap to toggle inlay hints in your
										-- code, if the language server you are using supports them
										--
										-- This may be unwanted, since they displace some of your code
										if client and client.server_capabilities.textDocument_inlayHint then
												map('<leader>th', function()
														vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
												end, '[T]oggle Inlay [H]ints')
										end
								end,
						})

						local capabilities = vim.lsp.protocol.make_client_capabilities()
						capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

						local servers = {
								-- clangd = {},
								-- gopls = {},
								-- pyright = {},
								-- rust_analyzer = {},
								-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
								--
								-- Some languages (like typescript) have entire language plugins that can be useful:
								--    https://github.com/pmizio/typescript-tools.nvim
								--
								-- But for many setups, the LSP (`tsserver`) will work just fine
								-- tsserver = {},
								--
								pyright = {
										capabilities = capabilities,
								},

								lua_ls = {
										-- cmd = {...},
										-- filetypes = { ...},
										capabilities = capabilities,
										settings = {
												Lua = {
														completion = {
																callSnippet = 'Replace',
														},
														-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
														-- diagnostics = { disable = { 'missing-fields' } },
												},
										},
								},
						}

						for server, settings in pairs(servers) do
								require('lspconfig')[server].setup(settings)
						end
				end,
		},
		{ -- Autocompletion
				'hrsh7th/nvim-cmp',
				event = 'InsertEnter',
				dependencies = {
						-- Snippet Engine & its associated nvim-cmp source
						{
								'L3MON4D3/LuaSnip',
								build = (function()
										-- Build Step is needed for regex support in snippets.
										-- This step is not supported in many windows environments.
										-- Remove the below condition to re-enable on windows.
										if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
												return
										end
										return 'make install_jsregexp'
								end)(),
								dependencies = {
										-- `friendly-snippets` contains a variety of premade snippets.
										--    See the README about individual language/framework/plugin snippets:
										--    https://github.com/rafamadriz/friendly-snippets
										{
												'rafamadriz/friendly-snippets',
												config = function()
														require('luasnip.loaders.from_vscode').lazy_load()
												end,
										},
								},
						},
						'saadparwaiz1/cmp_luasnip',
						'hrsh7th/cmp-nvim-lsp',
						'hrsh7th/cmp-path',
						'hrsh7th/cmp-buffer',
				},
				config = function()
						local cmp = require 'cmp'
						local luasnip = require 'luasnip'
						luasnip.config.setup {}

						cmp.setup {
								snippet = {
										expand = function(args)
												luasnip.lsp_expand(args.body)
										end,
								},
								completion = { completeopt = 'menu,menuone,noinsert' },

								-- For an understanding of why these mappings were
								-- chosen, you will need to read `:help ins-completion`
								--
								-- No, but seriously. Please read `:help ins-completion`, it is really good!

								mapping = cmp.mapping.preset.insert {
										-- Select the [n]ext item
										['<C-n>'] = cmp.mapping.select_next_item(),
										-- Select the [p]revious item
										['<C-p>'] = cmp.mapping.select_prev_item(),

										-- Scroll the documentation window [b]ack / [f]orward
										['<C-b>'] = cmp.mapping.scroll_docs(-4),
										['<C-f>'] = cmp.mapping.scroll_docs(4),

										-- Accept ([y]es) the completion.
										--  This will auto-import if your LSP supports it.
										--  This will expand snippets if the LSP sent a snippet.
										['<C-y>'] = cmp.mapping.confirm { select = true },

										-- If you prefer more traditional completion keymaps,
										-- you can uncomment the following lines
										['<CR>'] = cmp.mapping.confirm { select = true },
										['<Tab>'] = cmp.mapping.select_next_item(),
										['<S-Tab>'] = cmp.mapping.select_prev_item(),

										-- Manually trigger a completion from nvim-cmp.
										--  Generally you don't need this, because nvim-cmp will display
										--  completions whenever it has completion options available.
										['<C-Space>'] = cmp.mapping.complete {},

										-- Think of <c-l> as moving to the right of your snippet expansion.
										--  So if you have a snippet that's like:
										--  function $name($args)
										--    $body
										--  end
										--
										-- <c-l> will move you to the right of each of the expansion locations.
										-- <c-h> is similar, except moving you backwards.
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

										-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
										--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
								},
								sources = {
										{ name = 'nvim_lsp' },
										{ name = 'luasnip' },
										{ name = 'path' },
										{ name = 'buffer' },
								},
						}
				end,
		},
		{ -- Highlight, edit, and navigate code
				'nvim-treesitter/nvim-treesitter',
				build = ':TSUpdate',
				opts = {
						ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'java', 'python' },
						-- Autoinstall languages that are not installed
						auto_install = true,
						highlight = {
								enable = true,
								-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
								--  If you are experiencing weird indenting issues, add the language to
								--  the list of additional_vim_regex_highlighting and disabled languages for indent.
								additional_vim_regex_highlighting = { 'ruby' },
						},
						indent = { enable = true, disable = { 'ruby' } },
				},
				config = function(_, opts)
						-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

						---@diagnostic disable-next-line: missing-fields
						require('nvim-treesitter.configs').setup(opts)
				end,
		},
		{
				'gzagatti/vim-leuven-theme',
				lazy = false,
				priority = 1000,
				config = function()
						vim.opt.termguicolors = true
						vim.opt.guicursor = 'a:blinkon0-Cursor,i-ci:ver100'
						vim.cmd [[ colorscheme leuven ]]
				end
		},
		{
				'jpalardy/vim-slime',
				init = function()
						vim.g.slime_target = 'neovim'
				end,

		},
})

