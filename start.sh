#!/bin/bash

set -e

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHIVE1="$SCRIPT_DIR/hypr_part1.7z"
ARCHIVE2="$SCRIPT_DIR/hypr_part2.7z"
ARCHIVE3="$SCRIPT_DIR/hypr_part3.7z"
TARGET_DIR="$HOME"
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
LY_TEMP_DIR="$HOME/ly"

# Fancy header
clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════╗"
echo "║       Ultimate Hyprland + Ly Rice Installer      ║"
echo "╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# Dependency checks
command -v 7z >/dev/null || { echo -e "${RED}Error: p7zip-full not found!${NC}" | lolcat; exit 1; }
command -v lolcat >/dev/null && LOLCAT="lolcat" || LOLCAT="cat"

# Check all three archives exist
for arch in "$ARCHIVE1" "$ARCHIVE2" "$ARCHIVE3"; do
    [[ -f "$arch" ]] || { echo -e "${RED}Missing: $(basename "$arch")${NC}" | $LOLCAT; exit 1; }
done

# 1. Extract main config archives
echo -e "${YELLOW}Extracting configs (part1 + part2) → $TARGET_DIR ${NC}" | $LOLCAT
7z x "$ARCHIVE1" -o"$TARGET_DIR" -y | $LOLCAT
7z x "$ARCHIVE2" -o"$TARGET_DIR" -y | $LOLCAT

# 2. Extract wallpapers
echo -e "${YELLOW}Extracting wallpapers → $WALLPAPER_DIR ${NC}" | $LOLCAT
mkdir -p "$WALLPAPER_DIR"
7z x "$ARCHIVE3" -o"$WALLPAPER_DIR" -y | $LOLCAT

# 4. Install core packages
echo -e "${YELLOW}"
echo "Installing core Hyprland packages..."
echo -e "${NC}" | $LOLCAT

sudo pacman -Syu --noconfirm --needed \
    hyprland hypridle hyprlock hyprutils \
    foot fish thunar waybar ly swaync swww \
    polkit polkit-gnome wl-clipboard kdeconnect \
    rofi firefox playerctl grim slurp hyprpicker \
    jq fyi fuzzel blueman pavucontrol-qt pamixer \
    ttf-firacode-nerd starship fastfetch btop htop fd bc cliphist bat \
    noto-fonts-emoji eza nvim fzf 

git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && cd .. && rm rf yay/

sudo systemctl enable ly.service

chsh -s/usr/bin/fish

fc-cache -f

cd /home/zz/.config/hypr/scripts/ && chmod +x calendar.sh grimblast.sh workspace_action.sh && chmod +x rofi/music/rofi-music

# 3. Handle ly folder
if [[ -d "$LY_TEMP_DIR" ]]; then
    echo -e "${YELLOW}Installing Ly display manager → /etc/ly ${NC}" | $LOLCAT
    sudo rm -rf /etc/ly
    sudo mv "$LY_TEMP_DIR" /etc/ly
    echo -e "${GREEN}Ly installed successfully!${NC}" | $LOLCAT
else
    echo -e "${CYAN}No 'ly' folder found in archives${NC}" | $LOLCAT
fi

# Final epic message
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                  SETUP 100% COMPLETE!                    ║"
echo "║      Configs ✓    Wallpapers ✓    Ly ✓    Packages ✓    ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}" | $LOLCAT

exit 0