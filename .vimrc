syntax on
filetype plugin indent on

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'nordtheme/vim'
call vundle#end()            " required
filetype plugin indent on    " required

colorscheme nord

set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#303000 ctermbg=234

" Set to auto read when a file is changed from the outside
set autoread
" Sets how many lines of history VIM has to remember
set history=10000
" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch
" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2
" Use spaces instead of tabs
set expandtab
" Be smart when using tabs ;)
set smarttab
set number
set encoding=utf8
set nocompatible
set ruler
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
" Use Unix as the standard file type
set ffs=unix,dos,mac
" Always show the status line
set laststatus=2

set clipboard=unnamedplus

set wrap linebreak
