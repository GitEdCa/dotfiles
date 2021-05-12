" Specify a directory for plugins
call plug#begin()
Plug 'mfussenegger/nvim-jdtls'
Plug 'ctrlpvim/ctrlp.vim'
" Initialize plugin system
call plug#end()
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
" colors for syntax check
set termguicolors
let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
    let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection="0"
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

" CtrlP plugin
if executable('rg')
    let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
    let g:ctrlp_use_caching = 0
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" Change mapping
let g:ctrlp_map = '<Leader>p'
" Open buffer with CtrlP
nnoremap <Leader>b :CtrlPBuffer<CR>

" open quickfix after grep
augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END

" shift + insert to paste
map <silent> <S-Insert> "+p
imap <silent> <S-Insert> <Esc>"+pa

" set makeprg
autocmd FileType c,cpp setlocal makeprg=cl\ -Zi\ %\ user32.lib
"nnoremap <A-m> :make<bar>cw<CR>
nnoremap <A-m> :make<CR>

" set tcd when new tab
function! OnTabEnter(path)
  if isdirectory(a:path)
    let dirname = a:path
  else
    let dirname = fnamemodify(a:path, ":h")
  endif
  execute "tcd ". dirname
endfunction()

autocmd TabNewEntered * call OnTabEnter(expand("<amatch>"))

" ctags
" check  https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html

" init lsp server
if has('nvim-0.5')
  augroup lsp
    au!
    autocmd FileType java lua require'jdtls_setup'.setup()
  augroup end
endif
