local M = {}

local awful = require("awful")
local menubar = require("menubar")

local gears = require("gears")
local gfs = gears.filesystem

local togglemon = gfs.get_configuration_dir() .. "bin/togglemon"
local natscroll = gfs.get_configuration_dir() .. "bin/natscroll"
local tmux_start = gfs.get_configuration_dir() .. "../tmux/bin/tmux-start"

M.terminal = os.getenv("DOTFILES_TERMINAL_EMULATOR") or "alacritty"
M.editor = os.getenv("EDITOR") or "nvim"

menubar.utils.terminal = M.terminal -- Set the terminal for applications that require it

local function pgrep_spawn(cmd)
    return awful.spawn.with_shell("! pgrep " .. cmd .. " && " .. cmd)
end

function M.spawn_terminal()
    awful.spawn(M.terminal)
end

function M.spawn_tmux()
    awful.spawn({M.terminal, "-e", tmux_start})
end

function M.autostart()
    awful.spawn({ "setxkbmap", "de", "-variant", "nodeadkeys" }, false)
    awful.spawn(togglemon)
    awful.spawn(natscroll)

    awful.spawn.once("nm-applet")
    awful.spawn.once("xfce4-power-manager")
    awful.spawn.once("syncthing")
    pgrep_spawn("xfce4-clipman")
    pgrep_spawn("volumeicon")
end

return M
