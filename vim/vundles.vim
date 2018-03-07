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

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle (required)
Bundle "VundleVim/Vundle.vim"

Bundle 'altercation/vim-colors-solarized'

Bundle 'tpope/vim-markdown'
Bundle 'nelstrom/vim-markdown-folding'
Bundle 'rking/ag.vim'
Bundle 'python.vim'
Bundle 'artoj/qmake-syntax-vim'
Bundle 'vimwiki/vimwiki'

Bundle 'scrooloose/nerdtree'
Bundle 'christoomey/vim-tmux-navigator'

Bundle 'Valloric/YouCompleteMe'
Bundle 'rust-lang/rust.vim'
Bundle 'peterhoeg/vim-qml'

Bundle 'Shougo/vimproc.vim'
Bundle 'wincent/Command-T'

Bundle 'tmhedberg/SimpylFold'

"Filetype plugin indent on is required by vundle
filetype plugin indent on
