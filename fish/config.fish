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
fish_add_path ~/.dotfiles/bin
fish_add_path ~/go/bin
fish_add_path /opt/homebrew/opt/ruby/bin
fish_add_path ~/node_modules/.bin

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

        # Quick Python alias
        # see https://github.com/matplotlib/matplotlib/issues/28324
        alias py="ipython --pylab qt"
end

# Account-specific options
switch (whoami)
case mjk
    # Oxide account
    fish_add_path ~/oxide/humility/target/release
    fish_add_path ~/oxide/management-gateway-service/target/release
    fish_add_path /opt/homebrew/opt/gnu-sed/libexec/gnubin
    fish_add_path ~/oxide/lengths-of-wire/hiring-cli/target/release
    fish_add_path /Applications/ARM/bin

    alias py="/Users/mjk/Library/Python/3.11/bin/ipython"

    function h
        humility $argv
    end
    # Use `x` as an alias for `cargo xtask`, plus updating `HUMILITY_ARCHIVE`
    # if we're running a build or flash operation
    function x
        if string match -q -- "*hubris*" (pwd)
            cargo xtask $argv
            set -l out $status
            if string match -q --regex -- "(dist|flash|test)" $argv[1]
                for var in $argv[2..]
                    if string match -q --regex -- "(app|test)\/.*\.toml" $var
                        set name (dasel -f $var -r toml -w - name 2>/dev/null;
                               or dasel -f $var -r toml -w - patches.name)
                        export HUMILITY_ARCHIVE=(pwd)/target/$name/dist/default/build-$name-image-default.zip
                    end
                end
            end
            return $out
        else
            echo "Error: `x` is only allowed in a `hubris` directory" 1>&2
            return 1
        end
    end
end

# Set SHELL=fish (so tmux uses fish instead of zsh)
set --export SHELL (which fish)
test -e ~/.iterm2_shell_integration.fish ; and source ~/.iterm2_shell_integration.fish ; or true

# Color scheme for `bat`
set --export BAT_THEME ansi

# jujutsu tab completion
jj util completion fish | source
