# Use vim as our default editor
set --export EDITOR vim
alias make="make -j8"

# Make virtualenvs work
#eval (python3 -m virtualfish)

# Set SHELL=fish (so tmux uses fish instead of zsh)
set --export SHELL (which fish)

# Useful aliases
alias miniterm="python -m serial.tools.miniterm"
alias w="vim ~/wiki/index.md"
alias weather="curl --silent wttr.in/somerville,ma|grep -v wttr"
alias fix-inkscape='wmctrl -r Inkscape -e 0,2560,1440,1200,700'
alias ts='tmux new-session -s '
alias ta='tmux attach -t '
alias tl='tmux list-sessions'
alias git-merge-log='git log --format=\'format:# %cd %H %s\' --date=short --first-parent --reverse'

# Customize PATH
set -g Z_SCRIPT_PATH /usr/local/etc/profile.d/z.sh

set fish_user_paths ~/formlabs/mordor/firmwares/toolchain/gcc-arm-none-eabi/bin \
                    ~/.cargo/bin ~/go/bin ~/.dotfiles/git/

set fish_greeting
