#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
home_dir=${HOME:?HOME is not set}

find "$repo_dir/home" \( -type f -o -type l \) ! -name '*.example' -print | while IFS= read -r source; do
	rel=${source#"$repo_dir/home/"}
	target=$home_dir/$rel

	mkdir -p "$(dirname -- "$target")"
	if [ -L "$source" ]; then
		link_target=$(readlink -- "$source")
		case $link_target in
			/*) source_link=$link_target ;;
			*) source_link=$(dirname -- "$source")/$link_target ;;
		esac
	else
		source_link=$source
	fi

	if [ -L "$target" ]; then
		current=$(readlink -- "$target")
		if [ "$current" = "$source_link" ]; then
			continue
		fi
		printf 'refusing different symlink: %s -> %s\n' "$target" "$current" >&2
		exit 1
	fi

	if [ -e "$target" ]; then
		if ! cmp -s "$source" "$target"; then
			printf 'refusing changed file: %s\n' "$target" >&2
			exit 1
		fi
		rm -- "$target"
	fi

	ln -s "$source_link" "$target"
done
