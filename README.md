# Dotfiles

Personal dotfiles and setup manifests for `/home/fida` on CachyOS/Hyprland.

## Layout

- `home/` contains files intended to be linked into `$HOME`.
- `packages/pacman.txt` contains native repository packages.
- `packages/aur.txt` contains foreign/AUR packages.
- `packages/flatpak.txt` contains Flatpak app IDs.
- `scripts/` contains small setup helpers.

Hardware-specific files are not tracked. For Hyprland monitors, copy:

```sh
cp ~/.config/hypr/monitors.conf.example ~/.config/hypr/monitors.conf
```

Then edit `~/.config/hypr/monitors.conf` for the current machine.

## Apply Dotfiles

Install GNU Stow, then from this repository:

```sh
stow --target="$HOME" home
```

If a file already exists, move it aside or compare it before running Stow.

## Install Packages

The install script prints privileged `pacman` commands instead of running `sudo`.

```sh
./scripts/install-packages.sh
```

For Flatpaks, make sure Flathub is configured first.
