#!/bin/bash

options="󰮯\n󰣇\n\n\n"
selected=$(echo -e "$options" | rofi -dmenu)
case "$selected" in
    "󰮯")
        kitty --class floating-kitty ~/.config/scripts/rofi-menu-scripts/omarchy-pkg-install.sh ;;
    "󰣇")
        kitty --class floating-kitty ~/.config/scripts/rofi-menu-scripts/omarchy-pkg-aur-install.sh ;;
    "")
        ~/.config/scripts/rofi-menu-scripts/rofi-submenu-dirs.sh ;;
    "")
        kitty sh -c "~/.config/scripts/rofi-menu-scripts/nvimWrapper.sh;" ;;
    "")
        ~/.config/scripts/rofi-menu-scripts/rofi-submenu-autism.sh ;;
esac
