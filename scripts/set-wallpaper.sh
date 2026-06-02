#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
	printf 'usage: %s /path/to/wallpaper\n' "$0" >&2
	exit 2
fi

source=$1
if [ ! -f "$source" ]; then
	printf 'not a file: %s\n' "$source" >&2
	exit 1
fi

case ${source##*.} in
	jpg|JPG|jpeg|JPEG|png|PNG|webp|WEBP)
		ext=$(printf '%s' "${source##*.}" | tr '[:upper:]' '[:lower:]')
		[ "$ext" = jpeg ] && ext=jpg
		;;
	*)
		printf 'unsupported wallpaper extension: %s\n' "${source##*.}" >&2
		exit 1
		;;
esac

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
wallpaper_dir=$repo_dir/home/.local/share/wallpapers
live_dir=${HOME:?HOME is not set}/.local/share/wallpapers
target=wallpaper.$ext

mkdir -p "$wallpaper_dir" "$live_dir"
if [ "$(readlink -f -- "$source")" != "$(readlink -f -- "$wallpaper_dir/$target" 2>/dev/null || printf '')" ]; then
	cp -- "$source" "$wallpaper_dir/$target"
fi
ln -sfn "$target" "$wallpaper_dir/current"
ln -sfn "$wallpaper_dir/current" "$live_dir/current"

if command -v hyprctl >/dev/null 2>&1 && command -v hyprpaper >/dev/null 2>&1; then
	pkill hyprpaper 2>/dev/null || :
	nohup hyprpaper >/tmp/hyprpaper.log 2>&1 &
fi
