#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
failed=0

if [ -s "$repo_dir/packages/pacman.txt" ]; then
	if ! command -v pacman >/dev/null 2>&1; then
		printf 'pacman is required to install native packages.\n' >&2
		exit 1
	fi

	sudo pacman -S --needed - < "$repo_dir/packages/pacman.txt"
fi

if [ -s "$repo_dir/packages/aur.txt" ]; then
	if command -v paru >/dev/null 2>&1; then
		paru -S --needed - < "$repo_dir/packages/aur.txt"
	else
		printf 'paru is required to install AUR packages. Install paru, then rerun this script.\n' >&2
		failed=1
	fi
fi

if [ -s "$repo_dir/packages/flatpak.txt" ]; then
	if command -v flatpak >/dev/null 2>&1; then
		xargs -r flatpak install -y --user flathub < "$repo_dir/packages/flatpak.txt"
		"$repo_dir/scripts/configure-flatpak-overrides.sh"
	else
		printf 'flatpak is required to install Flatpak apps. Install flatpak and configure Flathub, then rerun this script.\n' >&2
		failed=1
	fi
fi

exit "$failed"
