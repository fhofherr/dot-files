local M = {}

local awful = require("awful")
require("awful.autofocus")

local _, lain = pcall(require, "lain")

local layouts = {}
local small_screen = 1
local big_screen = 2

layouts[small_screen] = awful.layout.suit.max
if lain then
    layouts[big_screen] = lain.layout.centerwork
    layouts[#layouts + 1] = awful.layout.suit.tile.right
else
    layouts[big_screen] = awful.layout.suit.tile.right
end
layouts[#layouts + 1] = awful.layout.suit.floating

function M.for_screen(screen)
    if screen.geometry.width > 1920 then
        return layouts[big_screen]
    end
    return layouts[small_screen]
end

function M.setup()
    awful.layout.layouts = layouts
end

return M
