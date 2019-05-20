filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'https://github.com/VundleVim/Vundle.vim.git'
Plugin 'https://github.com/elixir-editors/vim-elixir.git'
Plugin 'https://github.com/Yggdroot/indentLine.git'
Plugin 'https://github.com/vim-scripts/indentpython.vim.git'
Plugin 'https://github.com/vim-python/python-syntax.git'
call vundle#end()
filetype plugin indent on
let g:python_highlight_all = 1

set encoding=utf-8

" syntax highlight
syntax enable
color elflord

" nasm syntax for asm sources by default
autocmd FileType asm set filetype=nasm

" open file in same line
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

set undofile
set undodir=~/.vim/undo

set colorcolumn=128

set backspace=indent,eol,start
set ruler

cabbr Q q
cabbr W w
cabbr WQ wq

" add line numbers
set number

" search with highlight
hi MySearch ctermbg=LightBlue ctermfg=Brown
set hlsearch
set hl=l:MySearch

" flagging unnecessary whitespace
highlight BadWhitespace ctermbg=red guibg=darkred
autocmd BufRead,BufNewFile *.sh,*.py,*.pyw,*.ex,*.exs match BadWhitespace /\s\+$/

" set indentation for shell scripts
autocmd FileType sh setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
" don't indent commented yaml
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab indentkeys-=0# indentkeys-=<:>
