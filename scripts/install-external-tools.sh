#!/bin/sh
set -eu

need() {
	if ! command -v "$1" >/dev/null 2>&1; then
		printf '%s is required.\n' "$1" >&2
		printf 'Install it with: sudo pacman -S %s\n' "$1" >&2
		printf 'Then rerun this script.\n' >&2
		exit 1
	fi
}

install_codex() {
	need curl
	curl -fsSL https://chatgpt.com/codex/install.sh | sh
}

install_codexbar_cli() {
	need curl
	need tar
	need sed

	case "$(uname -m)" in
		x86_64) arch=x86_64 ;;
		aarch64 | arm64) arch=aarch64 ;;
		*)
			printf 'unsupported architecture for CodexBar CLI: %s\n' "$(uname -m)" >&2
			exit 1
			;;
	esac

	tag=$(
		curl -fsSL https://api.github.com/repos/steipete/CodexBar/releases/latest |
			sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' |
			sed -n '1p'
	)
	if [ -z "$tag" ]; then
		printf 'could not determine latest CodexBar release.\n' >&2
		exit 1
	fi

	tmpdir=$(mktemp -d)
	trap 'rm -rf "$tmpdir"' EXIT INT HUP TERM

	archive="CodexBarCLI-${tag}-linux-${arch}.tar.gz"
	curl -fL "https://github.com/steipete/CodexBar/releases/download/${tag}/${archive}" -o "$tmpdir/$archive"
	tar -xzf "$tmpdir/$archive" -C "$tmpdir"

	mkdir -p "$HOME/.local/share/codexbar-cli" "$HOME/.local/bin"
	install -m 0755 "$tmpdir/codexbar" "$HOME/.local/share/codexbar-cli/codexbar"
	[ -f "$tmpdir/VERSION" ] && install -m 0644 "$tmpdir/VERSION" "$HOME/.local/share/codexbar-cli/VERSION"
	ln -sfn "$HOME/.local/share/codexbar-cli/codexbar" "$HOME/.local/bin/codexbar"

	rm -rf "$tmpdir"
	trap - EXIT INT HUP TERM
}

install_codex
install_codexbar_cli
