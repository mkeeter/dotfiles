#!/bin/sh

# Basics
brew install python macvim
pip install powerline-status psutil

# Vim
ln -s $(pwd)/vim ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# GHCI
ln -s $(pwd)/ghci ~/.ghci

# tmux
ln -s $(pwd)/tmux ~/.tmux
ln -s ~/.tmux/tmux.conf ~/.tmux.conf

# Fish shell
ln -s $(pwd)/fish/config.fish ~/.config/fish/config.fish

# Guile Scheme
ln -s $(pwd)/guile ~/.guile

# install Inconsolata for Powerline
