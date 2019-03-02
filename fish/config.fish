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
alias weather="curl --silent wttr.in/somerville,ma|grep -v wttr"
alias fix-inkscape='wmctrl -r Inkscape -e 0,2560,1440,1200,700'
alias git-merge-log='git log --format=\'format:# %cd %H %s\' --date=short --first-parent --reverse'

# Configure Z for fast jumping
set -g Z_SCRIPT_PATH /usr/local/etc/profile.d/z.sh

# Customize PATH
set fish_user_paths /usr/local/bin ~/.cargo/bin ~/go/bin

set fish_greeting

# Configure rbenv
status --is-interactive; and source (rbenv init -|psub)
