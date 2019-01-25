filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'https://github.com/VundleVim/Vundle.vim.git'
Plugin 'https://github.com/elixir-editors/vim-elixir.git'
Plugin 'https://github.com/Yggdroot/indentLine.git'
Plugin 'https://github.com/vim-scripts/indentpython.vim.git'
call vundle#end()
filetype plugin indent on

set encoding=utf-8

" syntax highlight
syntax enable
color elflord

" nasm syntax for asm sources by default
au FileType asm set filetype=nasm

" open file in same line
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

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
au BufRead,BufNewFile *.py,*.pyw,*.ex,*.exs match BadWhitespace /\s\+$/
