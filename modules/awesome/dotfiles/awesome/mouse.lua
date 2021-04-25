local M = {}

local awful = require("awful")
local gears = require("gears")

local keyboard = require("dotfiles.awesome.keyboard")

-- Control floating windows with the mouse
M.client_buttons = gears.table.join(awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
end), awful.button({keyboard.mod}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.move(c)
end), awful.button({keyboard.mod}, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", {raise = true})
    awful.mouse.client.resize(c)
end))

M.taglist_buttons = gears.table.join(awful.button({}, 1,
                                                  function(t) t:view_only() end),
                                     awful.button({keyboard.mod}, 1, function(t)
    if client.focus then client.focus:move_to_tag(t) end
end), awful.button({}, 3, awful.tag.viewtoggle),
                                     awful.button({keyboard.mod}, 3, function(t)
    if client.focus then client.focus:toggle_tag(t) end
end), awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
                                     awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
end))

-- Create a wibox for each screen and add it
M.tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
    if c == client.focus then
        c.minimized = true
    else
        c:emit_signal("request::activate", "tasklist", {raise = true})
    end
end), awful.button({}, 3, function()
    awful.menu.client_list({theme = {width = 250}})
end), awful.button({}, 4, function() awful.client.focus.byidx(1) end),
                                      awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
end))

function M.setup()
    root.buttons(gears.table.join(awful.button({}, 4, awful.tag.viewnext),
                                  awful.button({}, 5, awful.tag.viewprev)))
end

return M
