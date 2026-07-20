# Dotfiles Enhancement — Productivity, Aesthetics & Terminal Tools

## Overview

Add 7 new tools/configs to the existing Catppuccin-themed Arch + i3 dotfiles: lazygit, eza + bat, starship, GTK theme, yazi, btop, and thefuck. Replace Oh My Zsh with antidote for faster startup. Update `setup-arch.sh` with all new dependencies.

## Components

### 1. Zsh + Starship (antidote)

**Replace Oh My Zsh with antidote** — a fast Zsh plugin manager compatible with OMZ plugins.

- **`.zshrc`** — rewritten from scratch:
  - Load antidote instead of `oh-my-zsh.sh`
  - Plugins: `git`, `sudo`, `zsh-autosuggestions` (same as current, sourced via antidote)
  - Aliases for `eza` and `bat`
  - `eval "$(thefuck --alias)"` integration
  - `eval "$(starship init zsh)"`
  - Keep: autostart X11 on TTY1, `$HOME/.cargo/bin` and `$HOME/.opencode/bin` in PATH, env source guard
- **`starship.toml`** — Catppuccin Mocha themed prompt at `~/.config/starship.toml`

**Stow dir: `zsh/`** (add `starship.toml` alongside `.zshrc`)

### 2. lazygit

- **`~/.config/lazygit/config.yml`** — Catppuccin Mocha color overrides, sensible keybindings

**Stow dir: `lazygit/`**

### 3. eza + bat

- **Zsh aliases** in `.zshrc`:
  - `ls` → `eza --icons=auto`
  - `la` → `eza -la --icons=auto`
  - `lt` → `eza -T --icons=auto` (tree)
  - `cat` → `bat --theme=Catppuccin-mocha`
- **`bat` theme file** — Catppuccin Mocha syntax highlighting theme at `~/.config/bat/themes/Catppuccin-mocha.tmTheme`

**Stow dir: included in `zsh/` and `bat/`**

### 4. GTK Theme (AUR)

- **`~/.config/gtk-3.0/settings.ini`** — Sets Catppuccin Mocha theme, icon theme, font
- **`~/.config/gtk-4.0/settings.ini`** — Same for GTK4 apps
- **`~/.gtkrc-2.0`** — GTK2 equivalent
- AUR package `catppuccin-gtk-theme-mocha` installed via `setup-arch.sh`

**Stow dir: `gtk/`**

### 5. yazi (terminal file manager)

- **`~/.config/yazi/yazi.toml`** — Catppuccin Mocha theme, file opener rules
- **`~/.config/yazi/keymap.toml`** — Keybindings (close to vim defaults)
- **`~/.config/yazi/theme.toml`** — Catppuccin Mocha color scheme

**Stow dir: `yazi/`**

### 6. btop

- **`~/.config/btop/btop.conf`** — Catppuccin Mocha theme, process sorting, temperature display

**Stow dir: `btop/`**

### 7. thefuck

- **Zsh integration** — single `eval $(thefuck --alias)` line in `.zshrc`
- Installed via `pip` or `pacman` in `setup-arch.sh`

### 8. setup-arch.sh updates

Add to pacman: `lazygit`, `bat`, `btop`, `thefuck`, `python-pip`
Add to AUR: `eza`, `catppuccin-gtk-theme-mocha`, `yazi`, `starship`
Add antidote install step (git clone or brew)

## File Map

```
dotfiles/
├── zsh/
│   ├── .zshrc
│   └── .config/
│       └── starship.toml
├── lazygit/
│   └── .config/
│       └── lazygit/
│           └── config.yml
├── bat/
│   └── .config/
│       └── bat/
│           └── themes/
│               └── Catppuccin-mocha.tmTheme
├── gtk/
│   ├── .gtkrc-2.0
│   └── .config/
│       ├── gtk-3.0/
│       │   └── settings.ini
│       └── gtk-4.0/
│           └── settings.ini
├── yazi/
│   └── .config/
│       └── yazi/
│           ├── yazi.toml
│           ├── keymap.toml
│           └── theme.toml
├── btop/
│   └── .config/
│       └── btop/
│           └── btop.conf
├── setup-arch.sh    (updated)
└── README.md        (updated)
```

## Dependencies

| Package | Source | Needed by |
|---------|--------|-----------|
| `antidote` | git/clone | zsh |
| `starship` | AUR | zsh prompt |
| `lazygit` | pacman | lazygit |
| `eza` | AUR | eza aliases |
| `bat` | pacman | bat aliases |
| `catppuccin-gtk-theme-mocha` | AUR | GTK theme |
| `yazi` | AUR | yazi |
| `btop` | pacman | btop |
| `thefuck` | pacman or pip | thefuck |

## Order of Implementation

1. zsh + starship (rewrite .zshrc, add starship.toml)
2. bat theme (config file only)
3. eza aliases (just zshrc additions)
4. thefuck (zshrc line + pip package)
5. lazygit (config file only)
6. yazi (config files only)
7. btop (config file only)
8. GTK theme (config files + AUR package)
9. setup-arch.sh (add all new packages)
10. README.md (update with new tools)
