# Use vim as our default editor
set --export EDITOR nvim
alias make="make -j8"

# Useful aliases
alias weather="curl --silent wttr.in/somerville,ma|grep -v wttr"

# Configure Z for fast jumping
set -g Z_SCRIPT_PATH /usr/local/etc/profile.d/z.sh

# Customize PATH
fish_add_path /usr/local/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/go/bin

# Reset the greeting
set fish_greeting

# Platform-specific options
switch (uname)
    case Darwin
        set --export HOMEBREW_GITHUB_API_TOKEN (cat ~/.config/brew/token)
        alias fix-inkscape='wmctrl -r Inkscape -e 0,2560,1440,1200,700'

        eval (/opt/homebrew/bin/brew shellenv)

        # Quick access to personal wiki
        alias w="nvim ~/wiki/index.md"
end

# Account-specific options
switch (whoami)
case mjk
    # Oxide account
    fish_add_path ~/oxide/humility/target/release
    function h
        humility $argv
    end
    function x
        cargo xtask $argv
    end
end

# Set SHELL=fish (so tmux uses fish instead of zsh)
set --export SHELL (which fish)
