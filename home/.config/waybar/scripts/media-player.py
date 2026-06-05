#!/usr/bin/env python3

import json
import subprocess
import time


MAX_LENGTH = 42
SCROLL_DELAY = 0.1
SCROLL_GAP = "   "


def playerctl(*args):
    return subprocess.run(
        ["playerctl", *args],
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        text=True,
    )


def emit(text="", css_class="stopped", tooltip=""):
    print(
        json.dumps(
            {
                "text": text,
                "class": css_class,
                "tooltip": tooltip,
            }
        ),
        flush=True,
    )


def metadata(field):
    result = playerctl("metadata", field)
    if result.returncode != 0:
        return ""
    return result.stdout.strip()


def current_track():
    status = playerctl("status")
    if status.returncode != 0:
        return None

    title = metadata("title")
    artist = metadata("artist")
    album = metadata("album")

    display = " - ".join(part for part in (artist, title) if part)
    if not display:
        display = title or artist

    tooltip_parts = [display]
    if album:
        tooltip_parts.append(album)

    return {
        "status": status.stdout.strip().lower(),
        "display": display,
        "tooltip": "\n".join(part for part in tooltip_parts if part),
    }


def scroll_text(text, offset):
    if len(text) <= MAX_LENGTH:
        return text, 0

    padded = f"{text}{SCROLL_GAP}"
    offset %= len(padded)
    looped = padded + padded
    return looped[offset : offset + MAX_LENGTH], offset + 1


def main():
    offset = 0
    previous = ""

    while True:
        track = current_track()
        if not track or not track["display"]:
            emit(css_class="stopped")
            previous = ""
            offset = 0
            time.sleep(1)
            continue

        if track["display"] != previous:
            previous = track["display"]
            offset = 0

        visible, offset = scroll_text(track["display"], offset)
        icon = "" if track["status"] == "playing" else ""
        css_class = "playing" if track["status"] == "playing" else "paused"
        emit(f"{icon}  {visible}", css_class, track["tooltip"])
        time.sleep(SCROLL_DELAY)


if __name__ == "__main__":
    main()
