# Use vim as our default editor
set --export EDITOR vim
alias make="make -j8"

# Useful aliases
alias weather="curl --silent wttr.in/somerville,ma|grep -v wttr"

# Configure Z for fast jumping
set -g Z_SCRIPT_PATH /usr/local/etc/profile.d/z.sh

# Customize PATH
set fish_user_paths /usr/local/bin ~/.cargo/bin ~/go/bin /usr/local/texlive/2014/bin/x86_64-darwin

# Reset the greeting
set fish_greeting

switch (uname)
    case Darwin
        source ~/.config/fish/config.darwin.fish
end

# Set SHELL=fish (so tmux uses fish instead of zsh)
set --export SHELL (which fish)
