-- [[ General options ]]
-- Left column and similar settings
vim.g.mapleader = " "
local opt = vim.opt
opt.number = true -- display line numbers
opt.relativenumber = true -- display relative line numbers
opt.numberwidth = 2 -- set width of line number column
opt.signcolumn = "yes" -- always show sign column
opt.wrap = false -- display lines as single line
opt.scrolloff = 4 -- number of lines to keep above/below cursor
opt.sidescrolloff = 4 -- number of columns to keep to the left/right of cursor

-- Tab spacing/behavior
opt.shiftwidth = 4 -- number of spaces inserted for each indentation level
opt.tabstop = 4 -- number of spaces inserted for tab character
opt.softtabstop = 4 -- number of spaces inserted for <Tab> key
opt.smartindent = true -- enable smart indentation
opt.breakindent = true -- enable line breaking indentation

-- General Behaviors
opt.backup = false -- disable backup file creation
opt.conceallevel = 0 -- so that `` is visible in markdown files
opt.fileencoding = "utf-8" -- set file encoding to UTF-8
opt.mouse = "a" -- enable mouse support
opt.showmode = false -- hide mode display
opt.splitbelow = true -- force horizontal splits below current window
opt.splitright = true -- force vertical splits right of current window
opt.termguicolors = true -- enable term GUI colors
opt.timeoutlen = 1000 -- set timeout for mapped sequences
opt.undofile = true -- enable persistent undo
opt.undodir        = os.getenv("HOME") .. "/.vim/undodir" -- set undo dir
opt.updatetime = 100 -- set faster completion
opt.writebackup = false -- prevent editing of files being edited elsewhere
opt.cursorline = true -- highlight current line
opt.list = true -- Sets how neovim will display certain whitespace characters in the editor.
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- chars to display
vim.g.netrw_banner = 0 -- Netrw hide banner

-- Searching Behaviors
opt.hlsearch = true -- highlight all matches in search
opt.ignorecase = true -- ignore case in search
opt.smartcase = true -- match case if explicitly stated
opt.inccommand = 'split' -- Preview substitutions live, as you type!

-- command line
vim.o.wildmenu = true -- Set wildmenu command
vim.o.wildmode = "list:longest:full" -- display wildmenu mode

-- fold methods
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "0"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 2
vim.opt.foldnestmax = 4


