# Dotfiles Enhancement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add lazygit, eza/bat, starship, GTK theme, yazi, btop, thefuck + replace Oh My Zsh with antidote.

**Architecture:** Each tool gets its own stow-able directory under `dotfiles/`. Configs are static files dropped into the standard XDG config paths. The zsh rewrite is the only structural change — all others are additive.

**Tech Stack:** zsh + antidote + starship, XDG-compliant configs, GNU Stow

## Global Constraints

- All configs use Catppuccin Mocha theme where applicable
- All new stow dirs follow the existing pattern: `tool/.config/tool/` or `tool/.toolrc`
- No generated/build files committed to git (parser binaries already excluded)
- `setup-arch.sh` must remain idempotent (`--needed`, `--noconfirm`)
- `.zshrc` must preserve: X11 autostart on TTY1, `$HOME/.cargo/bin` path, `$HOME/.opencode/bin` path, env source guard

---

### Task 1: Zsh rewrite + Starship

**Files:**
- Create: `zsh/.zsh_plugins.txt`
- Create: `zsh/.config/starship.toml`
- Modify: `zsh/.zshrc`
- Create: `zsh/.config/starship.toml.catppuccin` (Catppuccin Mocha theme)

- [ ] **Step 1: Write `.zsh_plugins.txt`**

This file lists plugins for antidote.

```bash
cat > zsh/.zsh_plugins.txt << 'EOF'
ohmyzsh/ohmyzsh path:plugins/git
ohmyzsh/ohmyzsh path:plugins/sudo
zsh-users/zsh-autosuggestions
EOF
```

- [ ] **Step 2: Write `starship.toml`**

Catppuccin Mocha themed starship prompt.

```bash
mkdir -p zsh/.config
cat > zsh/.config/starship.toml << 'EOF'
format = """\
[](#f5e0dc)\
$os\
$username\
[](bg:#cba6f7 fg:#181825)\
$directory\
[](fg:#cba6f7 bg:#89b4fa)\
$git_branch\
$git_status\
[](fg:#89b4fa bg:#a6e3a1)\
$nodejs\
$python\
$rust\
$golang\
[](fg:#a6e3a1 bg:#f9e2af)\
$docker_context\
[](fg:#f9e2af bg:#fab387)\
$time\
[](fg:#fab387)\
$line_break\
$character\
"""

fill = "$fill"

[character]
success_symbol = "[❯](#cba6f7)"
error_symbol = "[❯](#f38ba8)"
vimcmd_symbol = "[❮](#89b4fa)"

[os]
disabled = false
style = "bg:#f5e0dc fg:#181825"
format = "[ $symbol]($style)"

[os.symbols]
windows = ""
macos = ""
linux = ""

[username]
show_always = true
style_user = "bg:#f5e0dc fg:#181825"
format = "[ $user]($style)"

[directory]
style = "bg:#cba6f7 fg:#181825"
format = "[ $path]($style)"
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = " "
style = "bg:#89b4fa fg:#181825"
format = '[ $symbol$branch]($style)'

[git_status]
style = "bg:#89b4fa fg:#181825"
format = '[$all_status$ahead_behind]($style)'
conflicted = "🏳"
up_to_date = ""
untracked = " "
ahead = "⇡\${count}"
diverged = "⇕⇡\${ahead_count}⇣\${behind_count}"
behind = "⇣\${count}"
stashed = " "
modified = " "
staged = ""
renamed = " "
deleted = " "

[nodejs]
symbol = ""
style = "bg:#a6e3a1 fg:#181825"
format = '[ $symbol( $version)]($style)'

[golang]
symbol = ""
style = "bg:#a6e3a1 fg:#181825"
format = '[ $symbol( $version)]($style)'

[python]
symbol = ""
style = "bg:#a6e3a1 fg:#181825"
format = '[ $symbol( $version)]($style)'

[rust]
symbol = ""
style = "bg:#a6e3a1 fg:#181825"
format = '[ $symbol( $version)]($style)'

[docker_context]
symbol = ""
style = "bg:#f9e2af fg:#181825"
format = '[ $symbol( $context)]($style)'

[time]
disabled = false
time_format = "%H:%M"
style = "bg:#fab387 fg:#181825"
format = '[  $time]($style)'
EOF
```

- [ ] **Step 3: Write new `.zshrc`**

```bash
cat > zsh/.zshrc << 'ZSHEOF'
# Path to antidote
source ~/.antidote/antidote.zsh
antidote load "$HOME/.zsh_plugins.txt"

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
ZSHEOF
```

- [ ] **Step 4: Commit**

```bash
git add zsh/
git commit -m "feat: replace zsh with antidote + starship, add eza/bat/thefuck aliases"
```

---

### Task 2: bat theme

**Files:**
- Create: `bat/.config/bat/themes/Catppuccin-mocha.tmTheme`

- [ ] **Step 1: Create `Catppuccin-mocha.tmTheme`**

Download the official Catppuccin bat theme:

```bash
mkdir -p bat/.config/bat/themes
curl -o bat/.config/bat/themes/Catppuccin-mocha.tmTheme \
  https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20Mocha.tmTheme
```

- [ ] **Step 2: Commit**

```bash
git add bat/
git commit -m "feat: add catppuccin mocha bat theme"
```

---

### Task 3: lazygit config

**Files:**
- Create: `lazygit/.config/lazygit/config.yml`

- [ ] **Step 1: Write `config.yml`**

```bash
mkdir -p lazygit/.config/lazygit
cat > lazygit/.config/lazygit/config.yml << 'EOF'
gui:
  theme:
    lightTheme: false
    activeBorderColor:
      - "#cba6f7"
      - bold
    inactiveBorderColor:
      - "#6c7086"
    optionsTextColor:
      - "#89b4fa"
    selectedLineBgColor:
      - "#313244"
    selectedRangeBgColor:
      - "#313244"
    cherryPickedCommitBgColor:
      - "#45475a"
    cherryPickedCommitFgColor:
      - "#cba6f7"
    unstagedChangesColor:
      - "#f38ba8"
    defaultFgColor:
      - "#cdd6f4"
    searchingActiveBorderColor:
      - "#a6e3a1"

  authorColors:
    "*": "#b4befe"

  nerdFontsVersion: "3"

git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
EOF
```

- [ ] **Step 2: Commit**

```bash
git add lazygit/
git commit -m "feat: add lazygit config with catppuccin mocha theme"
```

---

### Task 4: yazi config

**Files:**
- Create: `yazi/.config/yazi/yazi.toml`
- Create: `yazi/.config/yazi/keymap.toml`
- Create: `yazi/.config/yazi/theme.toml`

- [ ] **Step 1: Write `yazi.toml`**

```bash
mkdir -p yazi/.config/yazi
cat > yazi/.config/yazi/yazi.toml << 'EOF'
[manager]
ratio = [1, 3, 4]
show_hidden = false
sort_by = "natural"
sort_dir_first = true
linemode = "none"

[preview]
max_width = 600
max_height = 900
cache_dir = "/tmp/yazi"

[opener]
edit = [
  { run = 'nvim "$@"', desc = "Neovim" },
]
open = [
  { run = 'xdg-open "$@"', desc = "System default" },
]
EOF
```

- [ ] **Step 2: Write `keymap.toml`**

```bash
cat > yazi/.config/yazi/keymap.toml << 'EOF'
[open]
enter = "open"

[quit]
q = "quit"
Q = "quit"

[arrow]
k = "arrow -1"
j = "arrow 1"

[close]
Esc = "escape"

[search]
/ = "search"
n = "search_next"
N = "search_prev"

[tasks]
t = "tasks_show"

[selection]
space = "toggle"
v = "toggle"

[parent]
h = "leave"
EOF
```

- [ ] **Step 3: Write `theme.toml`**

Common color scheme for yazi (Catppuccin Mocha).

```bash
cat > yazi/.config/yazi/theme.toml << 'EOF'
[manager]
preview = { bg = "#1e1e2e" }
cwd = { fg = "#cba6f7", bold = true }
hovered = { fg = "#cdd6f4", bg = "#313244" }
[manager.preview_hovered]
selected = { fg = "#f5e0dc", bg = "#45475a" }
[manager.find_keyword]
find = { fg = "#1e1e2e", bg = "#a6e3a1" }
find_position = { fg = "#1e1e2e", bg = "#89b4fa" }

[status]
separator_style = { fg = "#6c7086" }
mode_normal = { fg = "#cdd6f4", bg = "#181825" }
mode_select = { fg = "#181825", bg = "#cba6f7" }
mode_unset = { fg = "#cdd6f4", bg = "#6c7086" }
progress_label = { fg = "#a6e3a1", bold = true }
progress_bar = { fg = "#a6e3a1" }
permissions_t = { fg = "#a6e3a1" }
permissions_r = { fg = "#f9e2af" }
permissions_w = { fg = "#f38ba8" }
permissions_x = { fg = "#cba6f7" }
permissions_s = { fg = "#fab387" }
total = { fg = "#b4befe" }
[status.symlink]
broken = { fg = "#f38ba8", bold = true }
other = { fg = "#89dceb", bold = true }

[input]
border = { fg = "#6c7086" }
title = { fg = "#cdd6f4", bold = true }
value = { fg = "#cdd6f4" }
selected = { fg = "#1e1e2e", bg = "#89b4fa" }

[select]
border = { fg = "#6c7086" }
active = { fg = "#cdd6f4", bg = "#313244" }
inactive = { fg = "#a6adc8" }

[tasks]
border = { fg = "#6c7086" }
title = { fg = "#cdd6f4", bold = true }
hovered = { fg = "#cdd6f4", bg = "#313244" }

[which]
cols = 2
mask = { bg = "#1e1e2e" }
cand = { fg = "#cdd6f4", bg = "#313244" }
rest = { fg = "#a6adc8", bg = "#181825" }
[which.key]
first = { fg = "#cba6f7", bg = "#45475a", bold = true }
[which.desc]
first = { fg = "#cdd6f4", bg = "#45475a" }

[help]
on = { fg = "#a6e3a1", bold = true }
run = { fg = "#cdd6f4" }
desc = { fg = "#a6adc8" }
hovered = { fg = "#cdd6f4", bg = "#313244" }
footer = { fg = "#585b70" }
EOF
```

- [ ] **Step 4: Commit**

```bash
git add yazi/
git commit -m "feat: add yazi config with catppuccin mocha theme"
```

---

### Task 5: btop config

**Files:**
- Create: `btop/.config/btop/btop.conf`

- [ ] **Step 1: Write `btop.conf`**

```bash
mkdir -p btop/.config/btop
cat > btop/.config/btop/btop.conf << 'EOF'
color_theme = "catppuccin_mocha"
theme_background = false
proc_tree_view = false
proc_info = true
proc_gradient = true
proc_per_core = false
proc_reversed = false
proc_sorting = "cpu lazy"
proc_filter = ""
proc_foreground = true
proc_depth = 0
proc_highlight = true
proc_show_docker = true
cpu_graph_upper = 100
cpu_graph_lower = 0
cpu_invert_lower = false
cpu_single_graph = false
cpu_graph_operator = "average"
show_uptime = true
show_swap = true
show_io_stat = true
show_io_mode = false
show_disks = true
show_sensors = false
show_cmdline = true
show_clock = true
update_ms = 2000
EOF
```

Now create the Catppuccin Mocha theme file for btop:

```bash
mkdir -p btop/.config/btop/themes
cat > btop/.config/btop/themes/catppuccin_mocha.theme << 'THEME'
# Catppuccin Mocha for btop
theme[main_bg] = #1e1e2e
theme[main_fg] = #cdd6f4
theme[title] = #cba6f7
theme[hi_fg] = #89b4fa
theme[selected_bg] = #313244
theme[selected_fg] = #cdd6f4
theme[inactive_fg] = #6c7086
theme[proc_mem] = #a6e3a1
theme[proc_cpu] = #89b4fa
theme[core_load] = #f9e2af
theme[temp] = #f38ba8
theme[graph_cpu] = #89b4fa
theme[graph_mem] = #a6e3a1
theme[graph_net] = #cba6f7
theme[graph_proc] = #f9e2af
theme[div_line] = #45475a
THEME
```

- [ ] **Step 2: Commit**

```bash
git add btop/
git commit -m "feat: add btop config with catppuccin mocha theme"
```

---

### Task 6: GTK theme config

**Files:**
- Create: `gtk/.gtkrc-2.0`
- Create: `gtk/.config/gtk-3.0/settings.ini`
- Create: `gtk/.config/gtk-4.0/settings.ini`

- [ ] **Step 1: Write GTK2 config**

```bash
mkdir -p gtk/.config/gtk-3.0 gtk/.config/gtk-4.0
cat > gtk/.gtkrc-2.0 << 'EOF'
gtk-theme-name="Catppuccin-Mocha-Standard-Mauve-Dark"
gtk-icon-theme-name="Papirus-Dark"
gtk-font-name="JetBrainsMono Nerd Font 10"
gtk-cursor-theme-name="Bibata-Modern-Classic"
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintslight"
gtk-xft-rgba="rgb"
EOF
```

- [ ] **Step 2: Write GTK3 config**

```bash
cat > gtk/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=Catppuccin-Mocha-Standard-Mauve-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrainsMono Nerd Font 10
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintslight
gtk-xft-rgba=rgb
EOF
```

- [ ] **Step 3: Write GTK4 config**

```bash
cat > gtk/.config/gtk-4.0/settings.ini << 'EOF'
[Settings]
gtk-theme-name=Catppuccin-Mocha-Standard-Mauve-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrainsMono Nerd Font 10
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
EOF
```

- [ ] **Step 4: Commit**

```bash
git add gtk/
git commit -m "feat: add gtk theme config for catppuccin mocha"
```

---

### Task 7: Update setup-arch.sh and README

**Files:**
- Modify: `setup-arch.sh`
- Modify: `README.md`

- [ ] **Step 1: Update `setup-arch.sh`**

Add new packages to the pacman install list and add AUR packages.

Add to pacman list on line 14-17 (insert before the closing `\`):
```
  lazygit bat btop thefuck
```

Add to AUR packages on line 38:
```
  catppuccin-gtk-theme-mocha yazi starship eza
```

Add antidote install step after the Oh My Zsh block (around line 55):
```bash
# 3b. Install antidote
if [ ! -d "$HOME/.antidote" ]; then
  echo "Installing antidote..."
  git clone --depth 1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
else
  echo "antidote is already installed."
fi
```

Remove the Oh My Zsh section entirely, and update the stow command on line 108-109 to include new dirs:
```bash
stow -R i3 nvim polybar picom rofi alacritty zsh x11 dunst lazygit bat gtk yazi btop
```

- [ ] **Step 2: Update `README.md`**

Add a section about antidote (replacing Oh My Zsh). Update the quick install commands. Add the new tools to their relevant sections.

- [ ] **Step 3: Commit**

```bash
git add setup-arch.sh README.md
git commit -m "feat: update setup script and readme for new tools"
```
