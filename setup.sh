#!/usr/bin/env bash
##################################
## Daenschis PC Setup Script    ##
##################################
## Version 0.2                  ##
## Date 12.11.2025              ##
##################################

# On any command fail, or unset variable or pipeline fail, exit the script
set -euo pipefail
# Restrict word splitting
IFS=$'\n\t'

waybarDir="$HOME/.config/waybar"
waybarConf="$waybarDir/config.jsonc"

hyprlandDir="$HOME/.config/hypr"
hyprlandConf="$hyprlandDir/hyprland.conf"
hyprpaperConf="$hyprlandDir/hyprpaper.conf"

alacrittyDir="$HOME/.config/alacritty"
alacrittyConf="$alacrittyDir/alacritty.toml"

zshConf="$HOME/.zshrc"

echo "lets go, checking os..."
sleep 1

distro_id=""
distro_like=""

if [ -r /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    distro_id=${NAME:-}
    distro_like=${ID_LIKE:-}
    echo "running on ${distro:-Unknown}"
fi

# helper: create parent dir and copy file if source exists
_safe_cp() {
    local src=$1 dest=$2
    if [ -f "$src" ]; then
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
        echo "copied $src -> $dest"
    else
        echo "warning: source $src not found"
    fi
}

if [ "$distro_id" = "Fedora Linux" ]; then
    sudo dnf upgrade --refresh -y
    echo "installing dependencies"
    sudo dnf install -y pavucontrol zsh waybar tmux alacritty hyprpaper nmtui cheese grim slurp go rofi ripgrep fzf
    echo "removing wofi if present"
    sudo dnf remove -y wofi

    echo "installing oh-my-zsh if needed"
    if [ ! -f "$zshConf" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
    fi

    echo "copying configs"
    _safe_cp ./config.jsonc "$waybarConf"
    if [ ! -f "$hyprlandConf" ]; then
        _safe_cp ./hyprland.conf "$hyprlandConf"
        _safe_cp ./hyprpaper.conf "$hyprpaperConf"
        _safe_cp ./galaxy.jpg "$HOME/Pictures/galaxy.jpg"
    fi
    _safe_cp ./alacritty.toml "$alacrittyConf"

fi

if echo "$distro_like" | grep -qi 'arch'; then
    sudo pacman -Syu --noconfirm
    echo "installing dependencies"
    sudo pacman -S --noconfirm pavucontrol zsh waybar tmux alacritty hyprpaper cheese grim slurp go rofi ripgrep fzf
    echo "removing wofi if present"
    sudo pacman -R --noconfirm wofi || true

    echo "installing oh-my-zsh if needed"
    if [ ! -f "$zshConf" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
    fi

    echo "copying configs"
    _safe_cp ./config.jsonc "$waybarConf"
    if [ ! -f "$hyprlandConf" ]; then
        _safe_cp ./hyprland.conf "$hyprlandConf"
        _safe_cp ./hyprpaper.conf "$hyprpaperConf"
        _safe_cp ./galaxy.jpg "$HOME/Pictures/galaxy.jpg"
    fi
    _safe_cp ./alacritty.toml "$alacrittyConf"
fi

if command -v hyprctl >/dev/null 2>&1; then
        hyprctl reload || true
fi
