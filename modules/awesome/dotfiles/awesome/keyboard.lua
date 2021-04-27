-- vim: set foldmethod=marker:
local M = {}

local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")

local apps = require("dotfiles.awesome.apps")

-- Default mod.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xM.modmap or other tools.
-- However, you can use another M.modifier like Mod1, but it may interact with others.
M.mod = "Mod4"

local ctrl = "Control"
local alt = "Mod1"

-- {{{ Global key bindings
local global_keys = gears.table.join(
    awful.key({ M.mod }, "s", hotkeys_popup.show_help, {
        description = "show help",
        group = "awesome",
    }),
    awful.key({ ctrl, alt }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
    awful.key({ ctrl, alt }, "Right", awful.tag.viewnext, {
        description = "view next",
        group = "tag",
    }),
    awful.key({ M.mod }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

    awful.key({ M.mod }, "j", function()
        awful.client.focus.bydirection("down")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "Focus window below current window" }),

    awful.key({ M.mod }, "k", function()
        awful.client.focus.bydirection("up")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "Focus window above current window" }),

    awful.key({ M.mod }, "h", function()
        awful.client.focus.bydirection("left")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "Focus window left of current window" }),

    awful.key({ M.mod }, "l", function()
        awful.client.focus.bydirection("right")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "Focus window right of current window" }),

    -- Layout manipulation
    awful.key({ M.mod, ctrl }, "j", function()
        awful.client.swap.bydirection("down")
    end, { description = "swap with client below", group = "client" }),
    awful.key({ M.mod, ctrl }, "k", function()
        awful.client.swap.bydirection("up")
    end, { description = "swap with client above", group = "client" }),
    awful.key({ M.mod, ctrl }, "h", function()
        awful.client.swap.bydirection("left")
    end, { description = "swap with client left", group = "client" }),
    awful.key({ M.mod, ctrl }, "l", function()
        awful.client.swap.bydirection("right")
    end, { description = "swap with client right", group = "client" }),

    awful.key({ M.mod, "Shift" }, "j", function()
        awful.screen.focus_bydirection("down")
    end, {
        description = "focus the screen below the current screen",
        group = "screen",
    }),
    awful.key({ M.mod, "Shift" }, "k", function()
        awful.screen.focus_bydirection("up")
    end, {
        description = "focus the screen above the current screen",
        group = "screen",
    }),
    awful.key({ M.mod, "Shift" }, "h", function()
        awful.screen.focus_bydirection("left")
    end, {
        description = "focus the screen left of the current screen",
        group = "screen",
    }),
    awful.key({ M.mod, "Shift" }, "l", function()
        awful.screen.focus_bydirection("right")
    end, {
        description = "focus the screen right of the current screen",
        group = "screen",
    }),
    awful.key(
        { M.mod },
        "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),

    awful.key({ M.mod }, "Tab", function()
        awful.client.focus.byidx(1)
        if client.focus then
            client.focus:raise()
        end
    end, { description = "Cycle forwards through tag clients", group = "client" }),
    awful.key({ M.mod, "Shift" }, "Tab", function()
        awful.client.focus.byidx(-1)
        if client.focus then
            client.focus:raise()
        end
    end, { description = "Cycle backwards through tag clients", group = "client" }),

    -- Standard program
    awful.key({ ctrl, alt }, "t", function()
        awful.spawn(apps.terminal)
    end, { description = "open a terminal", group = "launcher" }),

    awful.key({ M.mod }, "Return", function()
        awful.spawn(apps.terminal)
    end, { description = "open a terminal", group = "launcher" }),

    awful.key({ M.mod, ctrl }, "r", awesome.restart, {
        description = "reload awesome",
        group = "awesome",
    }),
    awful.key({ M.mod, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

    awful.key({ M.mod }, "+", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ M.mod }, "-", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),

    awful.key({ M.mod, "Shift" }, "+", function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = "increase the number of master clients", group = "layout" }),
    awful.key({ M.mod, "Shift" }, "-", function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = "decrease the number of master clients", group = "layout" }),

    awful.key({ M.mod, ctrl }, "+", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }),
    awful.key({ M.mod, ctrl }, "-", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }),

    awful.key({ M.mod }, "space", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ M.mod, "Shift" }, "space", function()
        awful.layout.inc(-1)
    end, {
        description = "select previous",
        group = "layout",
    }), -- awful.key({ M.mod, ctrl }, "n",
    --           function ()
    --               local c = awful.client.restore()
    --               -- Focus restored client
    --               if c then
    --                 c:emit_signal(
    --                     "request::activate", "key.unminimize", {raise = true}
    --                 )
    --               end
    --           end,
    --           {description = "restore minimized", group = "client"}),
    -- Prompt
    awful.key({ M.mod }, "r", function()
        awful.screen.focused().mypromptbox:run()
    end, { description = "run prompt", group = "launcher" }),

    awful.key({ M.mod }, "x", function()
        awful.prompt.run({
            prompt = "Run Lua code: ",
            textbox = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval",
        })
    end, { description = "lua execute prompt", group = "awesome" }), -- Menubar
    awful.key({ M.mod }, "F2", function()
        menubar.show()
    end, { description = "show the menubar", group = "launcher" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
--
-- TODO: put this into a function that depends on the actual tags.
--       Don't M.modify global_keys in it but rather return a joined key
--       table.
for i = 1, 9 do
    global_keys = gears.table.join(
        global_keys, -- View tag only.
        awful.key({ M.mod }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ M.mod, "Control" }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ M.mod, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ M.mod, "Control", "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end
-- }}}

-- {{{ Per client key bindings
M.client_keys = gears.table.join(
    awful.key({ M.mod }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ M.mod }, "q", function(c)
        c:kill()
    end, {
        description = "close",
        group = "client",
    }),
    awful.key(
        { M.mod, "Control" },
        "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    awful.key({ M.mod, "Control" }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, { description = "move to master", group = "client" }),

    awful.key({ M.mod, "Shift" }, "o", function(c)
        c:move_to_screen()
    end, {
        description = "move to screen",
        group = "client",
    }),
    awful.key({ M.mod }, "t", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),

    -- awful.key({ M.mod,           }, "n",
    --     function (c)
    --         -- The client currently has the input focus, so it cannot be
    --         -- minimized, since minimized clients can't have the focus.
    --         c.minimized = true
    --     end ,
    --     {description = "minimize", group = "client"}),

    awful.key({ M.mod }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = "(un)maximize", group = "client" }),
    awful.key({ M.mod, "Control" }, "m", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),
    awful.key({ M.mod, "Shift" }, "m", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = "(un)maximize horizontally", group = "client" })
)
-- }}}

function M.setup()
    local keys = global_keys
    root.keys(keys)
end

return M
