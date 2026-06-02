#!/bin/sh
set -eu

need() {
	if ! command -v "$1" >/dev/null 2>&1; then
		printf '%s is required.\n' "$1" >&2
		exit 1
	fi
}

install_codex() {
	need curl
	curl -fsSL https://chatgpt.com/codex/install.sh | sh
}

install_codex
