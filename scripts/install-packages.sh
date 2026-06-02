#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

echo "Native packages:"
echo "  sudo pacman -S --needed - < '$repo_dir/packages/pacman.txt'"
echo

if [ -s "$repo_dir/packages/aur.txt" ]; then
	echo "AUR/foreign packages:"
	if command -v paru >/dev/null 2>&1; then
		echo "  paru -S --needed - < '$repo_dir/packages/aur.txt'"
	else
		echo "  install an AUR helper such as paru, then run:"
		echo "  paru -S --needed - < '$repo_dir/packages/aur.txt'"
	fi
	echo
fi

if [ -s "$repo_dir/packages/flatpak.txt" ]; then
	echo "Flatpak apps:"
	echo "  xargs -r flatpak install -y flathub < '$repo_dir/packages/flatpak.txt'"
	echo
fi
