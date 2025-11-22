#!/usr/bin/bash

# ================================================
#   Arch Linux Rice Installer - Openbox Edition
#   With optional Hyprland installer chaining
#   Made with love and too much lolcat <3
# ================================================

set -e  # Exit on any error

# Colors for non-lolcat parts (fallback)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if lolcat is installed
if ! command -v lolcat &> /dev/null; then
    echo "lolcat not found! Installing..." | lolcat
    sudo pacman -Sy --noconfirm lolcat || sudo pacman -Sy --noconfirm ruby-lolcat
fi

clear
echo
echo "╔══════════════════════════════════════════════════════════╗" | lolcat -a -d 2
echo "║    ██████╗ ██████╗ ███████╗███╗   ██╗██████╗  ██████╗  ║" | lolcat -a -d 3
echo "║   ██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔══██╗██╔═══██╗ ║" | lolcat -a -d 3
echo "║   ██║   ██║██████╔╝█████╗  ██╔██╗ ██║██████╔╝██║   ██║ ║" | lolcat -a -d 3
echo "║   ██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██╔══██╗██║   ██║ ║" | lolcat -a -d 3
echo "║   ╚██████╔╝██║     ███████╗██║ ╚████║██████╔╝╚██████╔╝ ║" | lolcat -a -d 3
echo "║    ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ║" | lolcat -a -d 3
echo "╚══════════════════════════════════════════════════════════╝" | lolcat -a -d 2
echo "               Ultimate Openbox Rice Installer               " | lolcat -a -s 50
echo

# ==================== CONFIGURABLE PACKAGES ====================
# Add or remove packages here easily
OPENBOX_PACKAGES=(
    openbox obconf obmenu-generator
    tint2 nitrogen picom-jonaburg-git
    lxappearance xdo xdotool
    ttf-jetbrains-mono ttf-font-awesome
    papirus-icon-theme arc-gtk-theme
    dunst rofi feh
    polybar
    p7zip  # needed to extract .7z
)

# ==============================================================

echo "What would you like to install today?" | lolcat
echo
echo "1) Openbox Rice Only" | lolcat
echo "2) Hyprland (will run ./start.sh after)" | lolcat
echo "3) Both (Openbox first → then Hyprland)" | lolcat
echo "4) Exit" | lolcat
echo
read -p "Choose [1-4]: " choice | lolcat

case $choice in
    1|3)
        echo
        echo "Starting Openbox rice installation..." | lolcat -a -d 10
        sleep 2

        echo "Updating system & installing dependencies..." | lolcat
        sudo pacman -Syu --noconfirm

        echo "Installing Openbox packages..." | lolcat -a -d 5
        sudo pacman -S --noconfirm --needed ${OPENBOX_PACKAGES[@]} || {
            echo "Some packages failed to install. Continuing anyway..." | lolcat
        }

        # Extract the config
        if [[ -f "./openbox.7z" ]]; then
            echo "Extracting your beautiful openbox.7z config to ~/.config/ ..." | lolcat -a -d 8
            mkdir -p ~/.config
            7z x openbox.7z -o~/.config/ -y > /dev/null 2>&1 || {
                echo "Failed to extract openbox.7z! Is it corrupted?" | lolcat
                exit 1
            }
            echo "Openbox config successfully deployed!" | lolcat -a -s 100
        else
            echo "openbox.7z not found in script directory!" | lolcat
            echo "Make sure openbox.7z is in the same folder as this script." | lolcat
            exit 1
        fi

        echo
        echo "Openbox rice installation complete!" | lolcat -a -d 10
        echo "You can now log out and select Openbox from your display manager." | lolcat

        # If user chose both, chain to Hyprland installer
        if [[ $choice == 3 ]]; then
            echo
            echo "Openbox done! Now launching Hyprland installer (start.sh)..." | lolcat -a -d 15
            sleep 3
            if [[ -f "./start.sh" && -x "./start.sh" ]]; then
                exec ./start.sh
            else
                echo "./start.sh not found or not executable!" | lolcat
                echo "Make it executable with: chmod +x start.sh" | lolcat
                exit 1
            fi
        fi
        ;;

    2)
        echo "Skipping Openbox → Jumping straight to Hyprland..." | lolcat
        sleep 2
        if [[ -f "./start.sh" && -x "./start.sh" ]]; then
            exec ./start.sh
        else
            echo "Hyprland installer (start.sh) not found or not executable!" | lolcat
            echo "Place your Hyprland installer as start.sh in this folder and chmod +x it" | lolcat
            exit 1
        fi
        ;;

    4|*)
        echo "Bye bye! Rice another day~" | lolcat -a -s 200
        exit 0
        ;;
esac

echo
echo "All done! Enjoy your new desktop!" | lolcat -a -d 10
echo "Made with ❤ by your favorite AI" | lolcat -a -s 50

exit 0
