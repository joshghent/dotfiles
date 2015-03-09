colorscheme railscasts

set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-rails.git'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-markdown'
Plugin 'vim-ruby/vim-ruby'
Plugin 'kchmck/vim-coffee-script'
Plugin 'pangloss/vim-javascript'
Plugin 'mileszs/ack.vim'
Plugin 'mattn/emmet-vim'
Plugin 'ervandew/supertab'
" ----- Making Vim look good ------------------------------------------
Plugin 'bling/vim-airline'
"
"  " ----- Vim as a programmer's text editor -----------------------------
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/syntastic'
Plugin 'xolox/vim-misc'
Plugin 'majutsushi/tagbar'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/a.vim'
Plugin 'godlygeek/tabular'


call vundle#end()            " required
filetype plugin indent on

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed
" Enhance command-line completion
set wildmenu
" Allow cursor keys in insert mode
set esckeys
" Allow backspace in insert mode
set backspace=indent,eol,start
" Optimize for fast terminal connections
set ttyfast
" Enable line numbers
set number
" Enable syntax highlighting
syntax on
" Highlight searches
set hlsearch
" Ignore case of searches
set ignorecase
" Enable mouse in all modes
set mouse=a
" Show the filename in the window titlebar
set title
" Send more characters
set ttyfast
" Auto indent
set autoindent
" The default for 'backspace' is very confusing to new users, so change it to a
" more sensible value.  Add 'set backspace&' to your ~/.vimrc to reset it.
set backspace=indent,eol,start
" Disable text wrap
set nowrap

" JSON
au BufRead,BufNewFile *.json set ft=json syntax=javascript

" Jade
au BufRead,BufNewFile *.jade set ft=jade syntax=jade

" Common Ruby files
au BufRead,BufNewFile Rakefile,Capfile,Gemfile,.autotest,.irbrc,*.treetop,*.tt set ft=ruby syntax=ruby

" Nu
au BufNewFile,BufRead *.nu,*.nujson,Nukefile setf nu

" Coffee Folding
au BufNewFile,BufReadPost *.coffee setl foldmethod=indent nofoldenable

" ZSH
au BufRead,BufNewFile .zsh_rc,.functions,.commonrc set ft=zsh

set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo
