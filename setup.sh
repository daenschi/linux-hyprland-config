#! /bin/bash
##################################
## Daenschis PC Setup Script 	##
##################################
## Version 0.2			##
## Date 12.11.2025		##
##################################

waybarDir=~/.config/waybar/
waybarConf=~/.config/waybar/config.jsonc

hyprlandDir=~/.config/hypr/
hyprlandConf=~/.config/hypr/hyprland.conf
hyprpaperConf=~/.config/hypr/hyprpaper.conf

alacrittyDir=~/.config/alacritty/
alacrittyConf=~/.config/alacritty/alacritty.toml

zshConf="~/.zshrc"

echo "lets go, checking os..."
sleep 2

if [ -r /etc/os-release ]; then
	. /etc/os-release
	distro=$NAME
	distri=$ID_LIKE	
	echo "running on $distro"
fi

if [ "$distro" = "Fedora Linux" ]; then
	sudo dnf update -y && sudo dnf upgrade -y
	echo "System up to date"
	echo "installing dependencies"
	sudo dnf install pavucontrol zsh waybar tmux alacritty hyprpaper nmtui cheese grim slurp go rofi ripgrep fzf -y
	echo "dependencies installed"
	sudo dnf remove wofi -y
	echo "intalling ohmyzisch"
	if [ ! -f .zshrc ]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi
	echo "copying configs"
	sleep 1
	# Copy Waybar
	if [ -d $waybarDir ]; then
		echo "waybar dir exists at $waybarDir"
		cp ./config.jsonc $waybarDir
		echo "waybar conf copied"
	else
		echo "creating dir and copying config"
		mkdir $waybarDir
		cp ./config.jsonc $waybarDir
		echo "waybar conf copied"
	fi
	# Copy hyprland and hyprpaper
	if [ ! -f $hyprlandConf ]; then
		echo "hyprland dir exists at $hyprlandDir"
		cp ./hyprland.conf ~/.config/hypr/hyprland.conf
		echo "hyprland conf copied"
		cp ./hyprpaper.conf $hyprpaperConf
		cp ./galaxy.jpg ~/Pictures/galaxy.jpg
		echo "copied hyprland and hyprpaper"
	fi
	# copy alacritty
	if [ -d $alacrittyDir ]; then
		echo "Copying alacritty conf"
	else
		mkdir $alacrittyDir
		cp ./alacritty.toml $alacrittyConf
		echo "Copied Alacritty conf"
	fi
	hyprctl reload
fi

if [ "$distri" = "arch" ]; then
	sudo pacman -Syu 
	echo "System up to date"
	echo "installing dependencies"
	sudo pacman -Sy pavucontrol zsh waybar tmux alacritty hyprpaper nmtui cheese grim slurp go rofi ripgrep fzf 
	echo "dependencies installed"
	sudo pacman -R wofi 
	echo "intalling ohmyzisch"
	if [ ! -f .zshrc ]; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	fi
	echo "copying configs"
	sleep 1
	# Copy Waybar
	if [ -d $waybarDir ]; then
		echo "waybar dir exists at $waybarDir"
		cp ./config.jsonc $waybarDir
		echo "waybar conf copied"
	else
		echo "creating dir and copying config"
		mkdir $waybarDir
		cp ./config.jsonc $waybarDir
		echo "waybar conf copied"
	fi
	# Copy hyprland and hyprpaper
	if [ ! -f $hyprlandConf ]; then
		echo "hyprland dir exists at $hyprlandDir"
		cp ./hyprland.conf ~/.config/hypr/hyprland.conf
		echo "hyprland conf copied"
		cp ./hyprpaper.conf $hyprpaperConf
		cp ./galaxy.jpg ~/Pictures/galaxy.jpg
		echo "copied hyprland and hyprpaper"
	fi
	# copy alacritty
	if [ -d $alacrittyDir ]; then
		echo "Copying alacritty conf"
	else
		mkdir $alacrittyDir
		cp ./alacritty.toml $alacrittyConf
		echo "Copied Alacritty conf"
	fi
fi
