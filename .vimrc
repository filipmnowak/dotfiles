filetype off
filetype plugin indent on
let g:python_highlight_all = 1

set encoding=utf-8
set undofile
set undodir=~/.vim/undo
set colorcolumn=128
set backspace=indent,eol,start
set ruler
" add line numbers
set number

" search with highlight
hi MySearch ctermbg=LightBlue ctermfg=Brown
set hlsearch
set hl=l:MySearch

" syntax highlight
syntax enable
color elflord

" don't make a fuss out of mis-cased commands
cabbr P p
cabbr Q q
cabbr W w
cabbr WQ wq

" nasm syntax for asm sources by default
autocmd FileType asm set filetype=nasm
" better hl for big files?
autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
" open file in same line
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
" flagging unnecessary whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
autocmd BufRead,BufNewFile *.sh,*.py,*.pyw,*.ex,*.exs match BadWhitespace /\s\+$/
" set indentation for shell scripts
autocmd FileType sh setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
" don't indent commented yaml
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab indentkeys-=0# indentkeys-=<:>

vmap Y :w! ~/.vim/temp/buffer.txt<CR>
vmap P :r! cat ~/.vim/temp/buffer.txt<CR>
nmap P :r! cat ~/.vim/temp/buffer.txt<CR>
