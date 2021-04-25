local M = {}

local awful = require("awful")
require("awful.autofocus")

local _, lain = pcall(require, "lain")

local big_screen = 1
local small_screen = 2

local layouts = {}

if lain then
    layouts[big_screen] = lain.layout.centerwork
else
    layouts[big_screen] = awful.layout.suit.tile.right
end
layouts[small_screen] = awful.layout.suit.max
layouts[#layouts + 1] = awful.layout.suit.floating

function M.for_screen(screen)
    if screen.geometry.width > 1920 then return layouts[big_screen] end
    return layouts[small_screen]
end

function M.setup() awful.layout.layouts = layouts end

return M
