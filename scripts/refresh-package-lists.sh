#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

pacman -Qqen > "$repo_dir/packages/pacman.txt"
pacman -Qqem > "$repo_dir/packages/aur.txt" || :
flatpak list --app --columns=application 2>/dev/null > "$repo_dir/packages/flatpak.txt" || :
