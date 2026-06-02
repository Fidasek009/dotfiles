#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
home_dir=${HOME:-/home/fida}

find "$repo_dir/home" -type f ! -name '*.example' -print | while IFS= read -r source; do
	rel=${source#"$repo_dir/home/"}
	target=$home_dir/$rel

	mkdir -p "$(dirname -- "$target")"

	if [ -L "$target" ]; then
		current=$(readlink -- "$target")
		if [ "$current" = "$source" ]; then
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

	ln -s "$source" "$target"
done
