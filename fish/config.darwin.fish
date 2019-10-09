set --export HOMEBREW_GITHUB_API_TOKEN (cat ~/.config/brew/token)
alias fix-inkscape='wmctrl -r Inkscape -e 0,2560,1440,1200,700'

# Quick access to personal wiki
alias w="vim ~/wiki/index.md"

# Configure rbenv
status --is-interactive; and source (rbenv init -|psub)
