# Path to antidote
source ~/.antidote/antidote.zsh
antidote load "$HOME/.zsh_plugins.txt"
autoload -Uz compinit && compinit

# Starship prompt
eval "$(starship init zsh)"

# Autostart X11/i3 on login on TTY1
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi

# System info on terminal startup
command -v afetch >/dev/null && afetch
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# eza aliases
alias ls='eza --icons=auto'
alias la='eza -la --icons=auto'
alias lt='eza -T --icons=auto'

# bat alias
alias cat='bat --theme="Catppuccin-mocha"'

# thefuck
eval "$(thefuck --alias)"

export PATH=$PATH:$HOME/.cargo/bin

# opencode
export PATH=$HOME/.opencode/bin:$PATH
