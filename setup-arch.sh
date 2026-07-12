#!/bin/bash
set -e

echo "==========================================="
echo "   Starting Arch Linux Dotfiles Setup      "
echo "==========================================="

# 1. Install pacman packages
echo "-> Installing official packages..."
sudo pacman -S --needed --noconfirm \
  i3-wm polybar picom rofi alacritty feh maim xclip xdotool \
  dex xss-lock i3lock network-manager-applet libpulse \
  brightnessctl zsh stow neovim ripgrep fd base-devel npm git curl

# 2. Check for yay and install AUR packages
if ! command -v yay &> /dev/null; then
  echo "-> 'yay' not found. Installing yay from the AUR..."
  TEMP_YAY=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$TEMP_YAY"
  
  # Navigate to the temp dir and run makepkg. 
  # (Note: makepkg will fail if this script is run as root)
  pushd "$TEMP_YAY" > /dev/null
  makepkg -si --noconfirm
  popd > /dev/null
  
  rm -rf "$TEMP_YAY"
else
  echo "-> 'yay' is already installed. Continuing..."
fi

echo "-> Installing AUR packages (Fonts)..."

yay -S --needed --noconfirm \
  ttf-meslo-nerd ttf-cascadia-code-nerd ttf-jetbrains-mono-nerd

# 3. Oh My Zsh and plugins
echo "-> Setting up Zsh and Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh (unattended)..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh is already installed."
fi

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Cloning zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
  echo "zsh-autosuggestions is already installed."
fi

# 4. Stow configurations
echo "-> Stowing dotfiles..."

# Oh My Zsh creates a default .zshrc on install which will block stow. Back it up if it's a real file (not our symlink).
if [ -f "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
  echo "Backing up default ~/.zshrc to ~/.zshrc.backup"
  mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Back up existing .config folders so stow doesn't fail
for app in i3 nvim polybar picom rofi alacritty; do
  if [ -e "$HOME/.config/$app" ] && [ ! -L "$HOME/.config/$app" ]; then
    echo "Backing up existing ~/.config/$app to ~/.config/${app}.backup"
    mv "$HOME/.config/$app" "$HOME/.config/${app}.backup"
  fi
done

# Move to the directory the script is in (so stow runs from the dotfiles root)
cd "$(dirname "$0")"

# Execute stow on all directories
stow i3 nvim polybar picom rofi alacritty zsh

echo "==========================================="
echo "   Setup Complete!                         "
echo "==========================================="
echo "Note: If your terminal doesn't start in zsh, run:"
echo "      chsh -s \$(which zsh)"
