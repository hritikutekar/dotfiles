# Dotfiles

This repository contains configuration files for my development environment on macOS, specifically focusing on window management, text editing, and system status.

## Components

### 🪟 [AeroSpace](aerospace/)

Configuration for **AeroSpace**, an i3-like tiling window manager for macOS.

- **Config**: `aerospace.toml`
- **Integration**: Configured to automatically launch **SketchyBar** and sync workspace states.

### 📝 [Neovim](nvim/)

A modern Neovim configuration built on top of **LazyVim**.

- **Features**: Fast, modular, and fully configured with LSP, formatting, and linting.
- **Structure**: Follows the standard LazyVim directory structure.

### 📊 [SketchyBar](sketchybar/)

A highly customizable status bar for macOS.

- **Features**: Includes custom scripts for system monitoring (Battery, CPU), media controls (Spotify), and window manager integration.
- **AeroSpace Integration**: Displays current workspace status synchronized with AeroSpace.

## Installation

### Prerequisites

Ensure you have **Homebrew** and **Git** installed on your macOS.
A [Nerd Font](https://www.nerdfonts.com/) (e.g., JetBrainsMono Nerd Font) is highly recommended for icons in Neovim and SketchyBar.

### 1. Install Tools

Use Homebrew to install the required applications:

```bash
# Install AeroSpace
brew install --cask nikitabobko/tap/aerospace

# Install Neovim
brew install neovim

# Install SketchyBar and SbarLua (for advanced configuration)
brew install felixkratz/formulae/sketchybar
curl -L https://github.com/FelixKratz/SbarLua/releases/download/nightly/SbarLua.tgz -o /tmp/SbarLua.tgz
tar -xzf /tmp/SbarLua.tgz -C /tmp
mv /tmp/SbarLua.so ~/.config/sketchybar/
```

### 2. Setup Configurations

Clone this repository to your `.config` directory:

```bash
# Backup existing configs if necessary
mv ~/.config/aerospace ~/.config/aerospace.bak
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.config/sketchybar ~/.config/sketchybar.bak

# Clone repository (assuming you want it in ~/.config directly)
# If you cloned elsewhere, symlink the folders:
# ln -s ~/path/to/dotfiles/aerospace ~/.config/aerospace
# ln -s ~/path/to/dotfiles/nvim ~/.config/nvim
# ln -s ~/path/to/dotfiles/sketchybar ~/.config/sketchybar
```

### 3. Post-Installation

- **AeroSpace**: Restart AeroSpace or run `aerospace reload-config`.
- **SketchyBar**: Start the service:

  ```bash
  brew services start sketchybar
  ```

- **Neovim**: Open `nvim`. LazyVim will automatically install plugins on the first launch.
