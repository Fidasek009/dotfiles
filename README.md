# Dotfiles

Personal dotfiles and setup manifests for a CachyOS/Hyprland user environment.

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

The install script installs packages from the tracked manifests. It uses `sudo` for native packages, `paru` for AUR packages, and `flatpak` for Flatpak apps.

```sh
./scripts/install-packages.sh
```

If `paru` or `flatpak` is missing, install and configure that prerequisite, then rerun the script.

## Wallpaper

Hyprland and Hyprlock read the current wallpaper through:

```text
~/.local/share/wallpapers/current
```

In the repo this is a symlink under `home/.local/share/wallpapers/`, so the real wallpaper can be a JPG, PNG, or WebP without changing Hyprlock or Hyprpaper config.

To change it:

```sh
./scripts/set-wallpaper.sh ~/Downloads/wallpaper.png
```

The script copies the image into the dotfiles repo, updates the `current` symlink, updates the live symlink, and restarts `hyprpaper` when available.

SDDM is separate from user dotfiles because its greeter runs as the `sddm` user and cannot read a private home directory. Its config and root-readable wallpaper copy are tracked under `system/`.

Install the local SDDM config with:

```sh
./scripts/install-sddm-config.sh
```

The script runs the privileged install commands through `sudo`. It installs the local SDDM config, installs the SDDM wallpaper copy, selects the tracked theme preset, and prints the restart command with a warning because restarting SDDM ends the current graphical session.

## Install External Tools

External tools that are not installed through `pacman`, `paru`, or Flatpak are installed from:

```sh
./scripts/install-external-tools.sh
```

Codex CLI is installed with OpenAI's official standalone installer, not npm. The installer places Codex under `~/.codex/packages/standalone/` and uses `~/.local/bin/codex` as the command on this machine. `.profile` adds `~/.local/bin` to `PATH`.
