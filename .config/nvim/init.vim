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
autocmd FileType c setlocal makeprg=cl\ -Zi\ %\ user32.lib
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
