" designed for vim 8+
" (see rwx.gg/vi for help)
let skip_defaults_vim=1
set nocompatible

" activate line numbers
set number

" disable relative line numbers, remove no to sample it
set norelativenumber

" tabs are the devil
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" more risky, but cleaner
set nobackup
set noswapfile
set nowritebackup
set hidden

"This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" high contrast for streaming, etc.
set background=dark
colorscheme gruvbox

" map leader key
let mapleader = ","
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

"To use `ALT+{h,j,k,l}` to navigate windows from any mode: >
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" exit terminal mode with ESC
tnoremap <Esc> <C-\><C-n>
" fzf
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-g> :GFiles<CR>
nnoremap <C-f> :Rg! 
let g:fzf_layout = {'down':'10'}

" set bash as shell
set shell=cmd.exe

" neoterm
let g:neoterm_default_mod="botright vertical"
let g:neoterm_size="65"
let g:neoterm_shell="bash"
nnoremap <leader>b :T build<CR>
