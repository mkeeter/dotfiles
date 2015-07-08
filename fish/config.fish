# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

# Theme
set fish_theme robbyrussell

# All built-in plugins can be found at ~/.oh-my-fish/plugins/
# Custom plugins may be added to ~/.oh-my-fish/custom/plugins/
# Enable plugins by adding their name separated by a space to the line below.
set fish_plugins theme z brew git-flow tmux vi-mode

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

# Use MacVim rather than system vim
alias vim=~/Applications/MacVim.app/Contents/MacOS/Vim
set --export EDITOR ~/Applications/MacVim.app/Contents/MacOS/Vim

# Set SHELL=fish (so tmux uses fish instead of zsh)
set --export SHELL (which fish)

# Useful aliases
alias miniterm="python -m serial.tools.miniterm"
alias org="vim ~/org"

# Customize PATH
set fish_user_paths ~/code/kokopelli                                  \
                    ~/code/gcc-arm-none-eabi-4_8-2013q4/bin           \
                    ~/mit/cba/repos/kokompe/dev/mod/bin               \
                    ~/Library/Python/2.7/bin                          \
                    ~/Library/Haskell/bin