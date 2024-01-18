--
-- minpac
--
vim.cmd('packadd minpac')

vim.fn['minpac#init']()
local Plug = vim.fn['minpac#add']
-- minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
Plug('k-takata/minpac', {type = 'opt'})
Plug('folke/tokyonight.nvim')
Plug('aktersnurra/no-clown-fiesta.nvim')
Plug('echasnovski/mini.nvim')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.5' })
Plug('natecraddock/workspaces.nvim')
Plug('tpope/vim-dispatch')
Plug('radenling/vim-dispatch-neovim')
Plug('nvim-treesitter/nvim-treesitter')
Plug('weilbith/nvim-floating-tag-preview')


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
vim.opt.scrolloff = 5
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.cmd[[colorscheme no-clown-fiesta]] -- theme

--
-- Mappings
--
vim.g.mapleader = " "
-- open netrw
vim.keymap.set("n", "<leader>ex", vim.cmd.Ex)
-- copy and paste to system clipboard
vim.keymap.set({"n", "v"}, "gy", "\"+y")
vim.keymap.set({"n", "v"}, "gY", "\"+Y")
vim.keymap.set("n", "gp", "\"+p")
vim.keymap.set("n", "gP", "\"+P")
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
-- alt keys for swaping buffers
vim.keymap.set({"t","n"}, "<A-1>", "<C-\\><C-n>:1wincmd w<CR>", {silent = true})
vim.keymap.set({"t","n"}, "<A-2>", "<C-\\><C-n>:2wincmd w<CR>", {silent = true})
vim.keymap.set({"t","n"}, "<A-3>", "<C-\\><C-n>:3wincmd w<CR>", {silent = true})
-- esc in Terminal mode to return in normal mode
vim.keymap.set('t', '<Esc>', "<C-\\><C-n>", {})
vim.keymap.set('n', '<leader>t', ":below split | term<CR>", {})
-- save file and return normal mode
vim.keymap.set({"n", 'i'}, '<C-s>', "<Esc>:w<Cr>", {})
vim.keymap.set("n", '<leader>b', ":ls<CR>:b<space>")
--
-- Plugins
--
require('mini.completion').setup()
require('mini.bracketed').setup()
--require('mini.comment').setup()
require('mini.pairs').setup()

--
-- Workspaces
--
require("workspaces").setup({
	-- path to a file to store workspaces data in
	-- on a unix system this would be ~/.local/share/nvim/workspaces
	path = vim.fn.stdpath("data") .. "/workspaces",

	-- to change directory for nvim (:cd), or only for window (:lcd)
	-- deprecated, use cd_type instead
	-- global_cd = true,

	-- controls how the directory is changed. valid options are "global", "local", and "tab"
	--   "global" changes directory for the neovim process. same as the :cd command
	--   "local" changes directory for the current window. same as the :lcd command
	--   "tab" changes directory for the current tab. same as the :tcd command
	--
	-- if set, overrides the value of global_cd
	cd_type = "global",

	-- sort the list of workspaces by name after loading from the workspaces path.
	sort = true,

	-- sort by recent use rather than by name. requires sort to be true
	mru_sort = true,

	-- option to automatically activate workspace when opening neovim in a workspace directory
	auto_open = false,

	-- enable info-level notifications after adding or removing a workspace
	notify_info = true,

	-- lists of hooks to run after specific actions
	-- hooks can be a lua function or a vim command (string)
	-- lua hooks take a name, a path, and an optional state table
	-- if only one hook is needed, the list may be omitted
	hooks = {
		add = {},
		remove = {},
		rename = {},
		open_pre = {},
		open = { "Telescope find_files"},
	},
})

vim.keymap.set('n', '<leader>w', "<cmd>Telescope workspaces<CR>", {})


--
-- Telescope
--
require('telescope').load_extension("workspaces")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, {})
vim.keymap.set('n', '<leader>g', builtin.git_files, {})
vim.keymap.set('n', '<leader>r', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

--
-- Treesitter
-- 
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "cpp", "html", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
