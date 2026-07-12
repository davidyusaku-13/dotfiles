# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Note: For zsh-autosuggestions, you must first run:
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
plugins=(git sudo zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh



# Custom Dotfiles Aliases
alias setgaps="~/.config/i3/scripts/set_gaps.sh"
alias setradius="~/.config/i3/scripts/set_radius.sh"

# Autostart X11/i3 on login on TTY1
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
