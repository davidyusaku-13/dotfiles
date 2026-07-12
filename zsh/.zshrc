# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git sudo)

source $ZSH/oh-my-zsh.sh

# Enable zsh-autosuggestions
# (Note: You may need to clone zsh-autosuggestions into ~/.zsh/ or use your distro's package manager)
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

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
