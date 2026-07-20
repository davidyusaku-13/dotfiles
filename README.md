# My Dotfiles

This repository contains my personal dotfiles, configured for an Arch Linux + X11 environment.
It combines the Catppuccin-themed i3/Polybar environment from Typecraft with the minimalist, high-performance Neovim setup from Tony's NixOS config.

## Installation / Prerequisites

To use these dotfiles fully, you need to install the following packages. Since you are on Arch Linux, you can use `pacman` for official packages and an AUR helper like `yay` or `paru` for the rest.

### 1. Core Desktop Environment (i3)

- **`i3-wm`**: The window manager itself.
- **`polybar`**: The top/bottom status bar.
- **`picom`**: The compositor (handles transparency, rounded corners, shadows).
- **`rofi`**: The application launcher and window switcher.
- **`alacritty`**: The GPU-accelerated terminal emulator.
- **`feh`**: Lightweight image viewer used to set the desktop background.

### 2. System Utilities & Keybinds

These are actively called by shortcuts inside `i3/config`:

- **`maim`**, **`xclip`**, **`xdotool`**: Used together for the screenshot keybinds (`Print` / `Ctrl+Print`).
- **`dex`**: Used to execute autostart (`.desktop`) files on login.
- **`xss-lock`**, **`i3lock-color`**: Used for screen locking.
- **`network-manager-applet`** (`nm-applet`): The network tray icon.
- **`libpulse`** (provides `pactl`): Used to control audio volume.
- **`brightnessctl`**: Used to control laptop screen brightness.

### 3. Terminal & Shell

- **`zsh`**: The shell.
- **antidote**: Zsh plugin manager (see [mattmc3/antidote](https://github.com/mattmc3/antidote)). Installed automatically by `setup-arch.sh`.
- **starship**: Cross-shell prompt. Installed via AUR as `starship`.
- **`bat`**: A `cat` clone with syntax highlighting.
- **`btop`**: Resource monitor.
- **`lazygit`**: Terminal UI for git.
- **`thefuck`**: Corrects mistyped console commands.
- **`eza`**: Modern `ls` replacement.
- **`stow`**: GNU Stow, the tool used to actually symlink these folders.

### 4. Neovim Requirements

- **`neovim`**: The editor (preferably v0.11+ or latest nightly).
- **`ripgrep`**, **`fd`**: Required for Telescope fuzzy-finding to work properly.
- **`gcc`**, **`make`**, **`npm`**: Often required by Tree-sitter or LSPs to compile parsers.

### 5. Fonts (Nerd Fonts)

The configs (Polybar, Rofi, Alacritty) explicitly expect these fonts to render icons correctly:

- **`ttf-meslo-nerd`** (Used by Polybar)
- **`ttf-cascadia-code-nerd`** (Used by Alacritty)
- **`ttf-jetbrains-mono-nerd`** (Used by Rofi and Neovim)

---

## Quick Install Command (Arch Linux)

You can install almost everything in one go:

```bash
# 1. Install official repository packages
sudo pacman -S i3-wm polybar picom rofi alacritty feh maim xclip xdotool dex xss-lock network-manager-applet libpulse brightnessctl zsh stow neovim ripgrep fd base-devel npm lazygit bat btop thefuck

# 2. Install AUR packages (Fonts & specific utilities)
yay -S ttf-meslo-nerd ttf-cascadia-code-nerd ttf-jetbrains-mono-nerd i3lock-color afetch catppuccin-gtk-theme-mocha yazi starship eza
```

## How to Apply Configurations

This repository uses **GNU Stow**. To apply a configuration, run `stow <folder>` from the root of this repository.

For example:

```bash
cd ~/dotfiles
stow i3 polybar picom rofi alacritty nvim zsh dunst x11 lazygit bat gtk yazi btop
```

_(Remember to backup or remove any existing default configurations at `~/.config/<app>` before stowing!)_
