# Use vim as our default editor
set --export EDITOR vim
alias make="make -j8"

# Make virtualenvs work
eval (python -m virtualfish)

# Set SHELL=fish (so tmux uses fish instead of zsh)
set --export SHELL (which fish)

# Useful aliases
alias miniterm="python -m serial.tools.miniterm"
alias w="vim ~/wiki/index.md"

# Customize PATH
set fish_user_paths ~/code/kokopelli                                  \
                    ~/code/gcc-arm-none-eabi-4_8-2013q4/bin           \
                    ~/mit/cba/repos/kokompe/dev/mod/bin               \
                    ~/Library/Haskell/bin                             \
                    /Developer/NVIDIA/CUDA-7.5/bin

set -g Z_SCRIPT_PATH /usr/local/etc/profile.d/z.sh

################################################################################

# Path to Oh My Fish install.
set -gx OMF_PATH "/Users/mkeeter/.local/share/omf"

# Customize Oh My Fish configuration path.
set -gx OMF_CONFIG "/Users/mkeeter/.dotfiles/omf"

# Load oh-my-fish configuration.
source $OMF_PATH/init.fish
