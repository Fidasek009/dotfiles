#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
source=$repo_dir/system/etc/sddm.conf.d/10-local.conf
target=/etc/sddm.conf.d/10-local.conf
theme_dir=/usr/share/sddm/themes/sddm-astronaut-theme
theme_conf=$repo_dir/system/usr/share/sddm/themes/sddm-astronaut-theme/Themes/fida.conf
theme_conf_target=$theme_dir/Themes/fida.conf
wallpaper=$repo_dir/system/usr/share/sddm/themes/sddm-astronaut-theme/Backgrounds/fida-wallpaper.jpg
wallpaper_target=$theme_dir/Backgrounds/fida-wallpaper.jpg
metadata=$theme_dir/metadata.desktop

if [ ! -f "$source" ]; then
	printf 'missing source config: %s\n' "$source" >&2
	exit 1
fi

if [ ! -f "$theme_conf" ]; then
	printf 'missing theme config: %s\n' "$theme_conf" >&2
	exit 1
fi

if [ ! -f "$wallpaper" ]; then
	printf 'missing SDDM wallpaper: %s\n' "$wallpaper" >&2
	exit 1
fi

sudo install -Dm644 "$source" "$target"
sudo install -Dm644 "$theme_conf" "$theme_conf_target"
sudo install -Dm644 "$wallpaper" "$wallpaper_target"
sudo sed -i 's|^ConfigFile=.*|ConfigFile=Themes/fida.conf|' "$metadata"

echo "Installed SDDM config and wallpaper."
echo
echo "The new SDDM wallpaper will appear after rebooting or restarting SDDM."
echo "Restarting SDDM will end the current graphical session:"
echo "  sudo systemctl restart sddm"
