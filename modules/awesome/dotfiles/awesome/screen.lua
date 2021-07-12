local M = {}

local awful = require("awful")
local _, lain = pcall(require, "lain")

local tag_names = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

local layouts_default = {
    awful.layout.suit.tile.right,
    awful.layout.suit.floating,
}

local layouts_big_screen = {
    awful.layout.suit.tile.left,
    awful.layout.suit.floating
}
if lain then
    table.insert(layouts_big_screen, 1, lain.layout.centerwork)
end

local function is_big(screen)
    return screen.geometry.width > 2560
end

function M.connect_for_each_screen(f)
    awful.screen.connect_for_each_screen(function(screen)
        -- Each screen has its own tag table.
        for i, tag_name in ipairs(tag_names) do
            local layouts = layouts_default
            if is_big(screen) then
                layouts = layouts_big_screen
            end

            local master_width_factor = 0.5
            local layout = layouts[1]
            if is_big(screen) and i ~= 1 then
                layout = layouts[2]
                master_width_factor = 0.75
            end

            awful.tag.add(tag_name, {
                layout = layout,
                layouts = layouts,
                master_width_factor = master_width_factor,
                screen = screen,
                selected = (i == 1),
            })
        end

        f(screen)
    end)
end

function M.setup()
    awful.screen.set_auto_dpi_enabled(true)
end

return M
