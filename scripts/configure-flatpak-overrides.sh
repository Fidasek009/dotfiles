#!/bin/sh
set -eu

need() {
	if ! command -v "$1" >/dev/null 2>&1; then
		printf '%s is required.\n' "$1" >&2
		printf 'Install it, then rerun this script.\n' >&2
		exit 1
	fi
}

app_installed() {
	flatpak info "$1" >/dev/null 2>&1
}

need flatpak

if app_installed com.visualstudio.code; then
	run_user_path=/run/user/$(id -u)
	discord_ipc_path=$run_user_path/app/com.discordapp.Discord

	flatpak override --user com.visualstudio.code \
		--share=network \
		--share=ipc \
		--socket=ssh-auth \
		--socket=pcsc \
		--device=all \
		--filesystem=host \
		--filesystem=host-os \
		--filesystem=host-etc:ro \
		--filesystem="$run_user_path" \
		--filesystem=/run/docker.sock \
		--filesystem=xdg-run/discord-ipc-0 \
		--filesystem=xdg-run/app/com.discordapp.Discord \
		--talk-name=org.freedesktop.Flatpak \
		--talk-name=org.freedesktop.Notifications \
		--talk-name=org.freedesktop.secrets \
		--system-talk-name=org.freedesktop.login1 \
		--env=DOCKER_HOST=unix:///run/docker.sock \
		--env=DISCORD_IPC_PATH="$discord_ipc_path"

	printf 'Configured Flatpak overrides for com.visualstudio.code.\n'
	printf 'Restart Visual Studio Code for the new sandbox permissions to apply.\n'
else
	printf 'Skipping com.visualstudio.code; it is not installed as a Flatpak.\n'
fi
