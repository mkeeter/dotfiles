#!/bin/sh
set -e -x

# Basics
brew install python macvim
pip install powerline-status psutil
mkdir -p ~/.config

# Vim
ln -s $(pwd)/vim ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Neovim
ln -s (pwd)/nvim ~/.config/nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
# You'll have to do some manual tweaking to bootstrap the 'impatient' plugin

# GHCI
ln -s $(pwd)/ghci ~/.ghci

# tmux
ln -s $(pwd)/tmux ~/.tmux
ln -s ~/.tmux/tmux.conf ~/.tmux.conf

# Fish shell
ln -s $(pwd)/fish/config.fish ~/.config/fish/config.fish
ln -s $(pwd)/fish/config.darwin.fish ~/.config/fish/config.darwin.fish
ln -s $(pwd)/fish/functions ~/.config/fish/functions
ln -s $(pwd)/fish/completions ~/.config/fish/completions

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fish -c "omf install robbyrussell z"

# Guile Scheme
ln -s $(pwd)/guile ~/.guile

# install Inconsolata for Powerline

# Powerline
ln -s $(pwd)/powerline ~/.config/powerline

# htop
ln -s $(pwd)/htop ~/.config/htop

# Tweak defaults
defaults write com.googlecode.oterm2 HotkeyTermAnimationDuration -float 0.05

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
