-- Portable preferences; hardware configuration stays local to this machine.
local mainMod = "SUPER"
local terminal = "kitty"

hl.env("LANG", "en_US.UTF-8")
hl.env("LANGUAGE", "en_US:en")
for _, category in ipairs({
    "CTYPE", "NUMERIC", "TIME", "COLLATE", "MONETARY", "MESSAGES",
    "PAPER", "NAME", "ADDRESS", "TELEPHONE", "MEASUREMENT", "IDENTIFICATION",
}) do
    hl.env("LC_" .. category, "en_US.UTF-8")
end
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("XDG_DATA_DIRS", os.getenv("HOME") .. "/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/usr/local/share:/usr/share")

-- Hyprland resolves the main symlink into dotfiles; find local modules in XDG_CONFIG_HOME.
local configHome = os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
package.path = configHome .. "/hypr/?.lua;" .. package.path
require("monitors")
require("function-keys")

hl.on("hyprland.start", function()
    hl.exec_cmd("command -v hyprpaper >/dev/null 2>&1 && { pgrep -x hyprpaper >/dev/null || hyprpaper; }")
    hl.exec_cmd("clipboard-watch")
end)
-- Like the former exec setting, run this on startup and each reload.
hl.exec_cmd("pgrep -x waybar >/dev/null || waybar")

hl.config({
    general = { gaps_in = 5, gaps_out = 8 },
    decoration = { rounding = 8 },
    input = {
        kb_layout = "cz,us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        touchpad = { natural_scroll = true },
    },
})

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("gtk-launch app.zen_browser.zen"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("flatpak run com.spotify.Client"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("flatpak run com.discordapp.Discord"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(terminal .. " codex"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("code"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("fuzzel"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("clipboard-history"))
hl.bind("PRINT", hl.dsp.exec_cmd("screenshot annotate"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("screenshot copy-region"))
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd("screenshot copy-screen"))
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))

for _, direction in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(mainMod .. " + " .. direction, hl.dsp.focus({ direction = direction }))
    hl.bind(mainMod .. " + SHIFT + " .. direction, hl.dsp.window.move({ direction = direction }))
end

-- Physical keycodes keep workspace shortcuts working on the Czech number row.
for workspace = 1, 10 do
    local key = "code:" .. (workspace + 9)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end
