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

# Tweak defaults
defaults write com.googlecode.oterm2 HotkeyTermAnimationDuration -float 0.05

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
