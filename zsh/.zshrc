# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY APPEND_HISTORY INC_APPEND_HISTORY

# Environment & PATH
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.opencode/bin:$PATH"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Path to antidote & completion caching
if [ -f "$HOME/.antidote/antidote.zsh" ]; then
  source "$HOME/.antidote/antidote.zsh"
  autoload -Uz compinit
  if [ $(date +%s) -lt $(( $(stat -c %Y ~/.zcompdump 2>/dev/null || echo 0) + 86400 )) ]; then
    compinit -C
  else
    compinit
  fi
  antidote load "$HOME/.zsh_plugins.txt"
fi

# zsh-autosuggestions (must be after prompt)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#585b70"
bindkey '^ ' autosuggest-accept

# Starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Autostart X11/i3 on login on TTY1
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
  exec startx
fi

# System info on terminal startup
command -v afetch >/dev/null 2>&1 && afetch

# eza aliases
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=auto'
  alias la='eza -la --icons=auto'
  alias lt='eza -T --icons=auto'
fi

# bat alias
command -v bat >/dev/null 2>&1 && alias cat='bat --theme="Catppuccin-mocha"'

# thefuck (lazy loaded for fast shell startup)
if command -v thefuck >/dev/null 2>&1; then
  fuck() {
    unfunction fuck
    eval "$(thefuck --alias)"
    fuck "$@"
  }
fi

