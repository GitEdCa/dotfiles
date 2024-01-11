--
-- Set
--
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.rnu = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.cmd.colorscheme('rose-pine') --theme

--
-- Global Remapping
--
vim.g.mapleader = " "
-- open netrw
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)
-- copy and paste to system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("n", "<leader>p", "\"+p")
vim.keymap.set("n", "<leader>P", "\"+P")
-- n and N always the same direction
local expr = {silent = true, expr = true, remap = false}
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", expr)
vim.keymap.set("n", "N", "'nN'[v:searchforward]", expr)
--changing word and keep word in / register
vim.keymap.set("n", "cn", "*``cgn")
--indent recent pasted code
vim.keymap.set("n", "<leader>=", "`[v`]=")

-- apply formatter
vim.keymap.set("n", "<F10>", ":%!clang-format<CR>")
-- run make
vim.keymap.set("n", "<F9>", ":w<CR> :Make<CR>")

--
-- terminal mode
--
local api = vim.api
api.nvim_command("autocmd TermOpen * startinsert")             -- starts in insert mode
api.nvim_command("autocmd TermOpen * setlocal nonumber nornu") -- no numbers
api.nvim_command("autocmd TermEnter * setlocal signcolumn=no") -- no sign column
vim.keymap.set('t', '<esc>', "<C-\\><C-n>")                    -- esc to exit insert mode
vim.keymap.set("n", "<leader>t", ":vsplit term://zsh<CR>")     -- split terminal

--
-- autocmds
--
--api.nvim_command("autocmd BufEnter * vertical res+40") -- focus buffer


--
-- Plugins
--

--
-- Fugitive
--
vim.keymap.set("n", "<leader>gs", vim.cmd.Git);

--
-- Telescope
--
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.git_files, {})
vim.keymap.set('n', '<leader>r', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

--
-- Lsp
--
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
  --lsp_zero.default_keymaps({buffer = bufnr})
end)
lsp_zero.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

local cmp = require('cmp')
local cmp_select  = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
	sources = {
		{name = 'path'},
		{name = 'nvim_lsp'},
		{name = 'nvim_lua'},
		{name = 'luasnip', keyword_length = 2},
		{name = 'buffer', keyword_length = 3},
	},
	formatting = lsp_zero.cmp_format(),
	mapping = cmp.mapping.preset.insert({
		--['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		--['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		--['<C-y>'] = cmp.mapping.confirm({ select = true }),
		--['<C-Space>'] = cmp.mapping.complete(),
	}),
})
-- here you can setup the language servers 
require('lspconfig').clangd.setup({})

--
-- Treesitter
--
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

--
-- UndoTree
--
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
