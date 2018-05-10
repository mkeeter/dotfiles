# Use vim as our default editor
set --export EDITOR vim
alias make="make -j8"

# Make virtualenvs work
eval (python3 -m virtualfish)

# Set SHELL=fish (so tmux uses fish instead of zsh)
set --export SHELL (which fish)

# Useful aliases
alias miniterm="python -m serial.tools.miniterm"
alias w="vim ~/wiki/index.md"
alias weather="curl wttr.in/somerville,ma"
alias fix-inkscape='wmctrl -r Inkscape -e 0,2560,1440,1200,700'

# Customize PATH
set -g Z_SCRIPT_PATH /usr/local/etc/profile.d/z.sh

################################################################################
