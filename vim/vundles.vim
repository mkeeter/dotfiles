" ========================================
" Vim plugin configuration
" ========================================
"
" This file contains the list of plugin installed using vundle plugin manager.
" Once you've updated the list of plugin, you can run vundle update by issuing
" the command :BundleInstall from within vim.

" Filetype off is required by vundle
filetype on
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle (required)
Bundle "gmarik/vundle"

Bundle 'gabrielhaim/vim-colors-solarized'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-endwise'
Bundle 'Raimondi/delimitMate'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'python.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'wincent/Command-T'

"Filetype plugin indent on is required by vundle
filetype plugin indent on
