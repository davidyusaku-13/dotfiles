# Path to antidote
source ~/.antidote/antidote.zsh
autoload -Uz compinit && compinit
antidote load "$HOME/.zsh_plugins.txt"

# zsh-autosuggestions (must be after prompt)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"
bindkey '^ ' autosuggest-accept

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
