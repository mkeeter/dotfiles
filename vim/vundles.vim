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

Bundle 'vimwiki/vimwiki'

Bundle 'scrooloose/nerdtree'
Bundle 'christoomey/vim-tmux-navigator'

Bundle 'Valloric/YouCompleteMe'

" Language support
Bundle 'python.vim'
Bundle 'artoj/qmake-syntax-vim'
Bundle 'rust-lang/rust.vim'
Bundle 'peterhoeg/vim-qml'
Bundle 'ziglang/zig.vim'

" FZF everywhere
Bundle 'junegunn/fzf.vim'
Bundle 'mhinz/vim-grepper'
set rtp+=/usr/local/opt/fzf

"Filetype plugin indent on is required by vundle
filetype plugin indent on
