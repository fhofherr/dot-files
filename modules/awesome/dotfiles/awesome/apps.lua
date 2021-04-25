local M = {}

local awful = require("awful")
local menubar = require("menubar")

M.terminal = os.getenv("DOTFILES_TERMINAL_EMULATOR") or "alacritty"
M.editor = os.getenv("EDITOR") or "nvim"

menubar.utils.terminal = M.terminal -- Set the terminal for applications that require it

local function pgrep_spawn(cmd)
    return awful.spawn.with_shell("! pgrep " .. cmd .. " && " .. cmd)
end

function M.autostart()
    awful.spawn({"setxkbmap", "de", "-variant", "nodeadkeys"}, false)

    awful.spawn.once("picom")
    awful.spawn.once("nm-applet")
    awful.spawn.once("xfce4-power-manager")
    awful.spawn.once("nextcloud")
    pgrep_spawn("xfce4-clipman")
    pgrep_spawn("volumeicon")
end

return M
