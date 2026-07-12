# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Note: For zsh-autosuggestions, you must first run:
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
plugins=(git sudo zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


# Aliases from NixOS config
alias btw="echo i use nixos, btw"
alias sr="sudo reboot"
alias gp="git pull"
alias gf="git fetch"
alias gs="git status"

# Note: The NixOS rebuild alias was left here for reference if you plan to use this on NixOS
# alias rb="sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-btw"

# Autostart X11/i3 on login (Adapted from the NixOS Hyprland snippet)
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi
