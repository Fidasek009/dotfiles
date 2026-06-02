# Dotfiles

Personal dotfiles and setup manifests for `/home/fida` on CachyOS/Hyprland.

## Layout

- `home/` contains files intended to be linked into `$HOME`.
- `packages/pacman.txt` contains native repository packages.
- `packages/aur.txt` contains installed foreign/AUR packages to install with `paru`.
- `packages/flatpak.txt` contains Flatpak app IDs.
- `scripts/` contains small setup helpers.

The active login shell is fish. Shell configuration is tracked through `home/.config/fish/config.fish`; bash and zsh startup files are intentionally not managed.

Hardware-specific files are not tracked. For Hyprland monitors, copy:

```sh
cp ~/.config/hypr/monitors.conf.example ~/.config/hypr/monitors.conf
```

Then edit `~/.config/hypr/monitors.conf` for the current machine.

## Apply Dotfiles

Use the standard dotfiles entrypoint:

```sh
./install.sh
```

It calls the included linker:

```sh
./scripts/link-dotfiles.sh
```

It refuses to overwrite live files that differ from the repo copy. Hardware-specific files such as `~/.config/hypr/monitors.conf` stay outside the repo.

## Install Packages

The install script prints privileged `pacman` commands instead of running `sudo`.

```sh
./scripts/install-packages.sh
```

For Flatpaks, make sure Flathub is configured first.

## Install External Tools

External tools that are not installed through `pacman`, `paru`, or Flatpak are installed from:

```sh
./scripts/install-external-tools.sh
```

Codex CLI is installed with OpenAI's official standalone installer, not npm. The installer places Codex under `~/.codex/packages/standalone/` and uses `~/.local/bin/codex` as the command on this machine. `.profile` adds `~/.local/bin` to `PATH`.
