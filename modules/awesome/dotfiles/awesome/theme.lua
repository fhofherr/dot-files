local M = {}

local beautiful = require("beautiful")
local theme_assets = require("beautiful.theme_assets")

local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local _, lainh = pcall(require, "lain.helpers")

local function find_wallpaper()
    local wallpaper = os.getenv("HOME") .. "/Wallpapers/kde_plasma_scenery_95_4k.png"
    if gfs.file_readable(wallpaper) then
        return wallpaper
    end
    return themes_path .. "default/background.png"
end

function M.set_wallpaper(s)
    if not beautiful.wallpaper then
        beautiful.wallpaper = find_wallpaper()
    end

    local wallpaper = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
end

local theme = {
    font = "Iosevka Nerd Font 11",

    border_width = dpi(1),
    useless_gap = dpi(3),
    gap_single_client = true,

    menu_submenu_icon = themes_path .. "default/submenu.png",
    menu_height = dpi(15),
    menu_width = dpi(100),

    titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png",
    titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png",

    titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png",
    titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png",

    titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png",
    titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png",
    titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png",
    titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png",

    titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png",
    titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png",
    titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png",
    titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png",

    titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png",
    titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png",
    titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png",
    titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png",

    titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png",
    titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png",
    titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png",
    titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png",

    layout_fairh = themes_path .. "default/layouts/fairhw.png",
    layout_fairv = themes_path .. "default/layouts/fairvw.png",
    layout_floating = themes_path .. "default/layouts/floatingw.png",
    layout_magnifier = themes_path .. "default/layouts/magnifierw.png",
    layout_max = themes_path .. "default/layouts/maxw.png",
    layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png",
    layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png",
    layout_tileleft = themes_path .. "default/layouts/tileleftw.png",
    layout_tile = themes_path .. "default/layouts/tilew.png",
    layout_tiletop = themes_path .. "default/layouts/tiletopw.png",
    layout_spiral = themes_path .. "default/layouts/spiralw.png",
    layout_dwindle = themes_path .. "default/layouts/dwindlew.png",
    layout_cornernw = themes_path .. "default/layouts/cornernww.png",
    layout_cornerne = themes_path .. "default/layouts/cornernew.png",
    layout_cornersw = themes_path .. "default/layouts/cornersww.png",
    layout_cornerse = themes_path .. "default/layouts/cornersew.png",

    -- Define the icon theme for application icons. If not set then the icons
    -- from /usr/share/icons and /usr/share/icons/hicolor will be used.
    icon_theme = nil,
}

theme.wallpaper = find_wallpaper()

if lainh then
    theme.layout_cascade = lainh.icons_dir .. "layout/default/cascade.png"
    theme.layout_cascadetile = lainh.icons_dir .. "layout/default/cascadetile.png"
    theme.layout_cascadetilew = lainh.icons_dir .. "layout/default/cascadetilew.png"
    theme.layout_cascadew = lainh.icons_dir .. "layout/default/cascadew.png"
    theme.layout_centerfair = lainh.icons_dir .. "layout/default/centerfair.png"
    theme.layout_centerfairw = lainh.icons_dir .. "layout/default/centerfairw.png"
    theme.layout_centerwork = lainh.icons_dir .. "layout/default/centerwork.png"
    theme.layout_centerworkh = lainh.icons_dir .. "layout/default/centerworkh.png"
    theme.layout_centerworkhw = lainh.icons_dir .. "layout/default/centerworkhwh.png"
    theme.layout_termfair = lainh.icons_dir .. "layout/default/termfair.png"
    theme.layout_termfairw = lainh.icons_dir .. "layout/default/termfairw.png"
end

theme.bg_normal = "#222222"
theme.bg_focus = "#535d6c"
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = "#222222"

theme.fg_normal = "#aaaaaa"
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.border_normal = "#000000"
theme.border_focus = "#535d6c"
theme.border_marked = "#91231c"

local function init_theme()
    -- Generate Awesome icon:
    theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

    -- Generate taglist squares:
    local taglist_square_size = dpi(4)
    theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
    theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

    -- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
    beautiful.init(theme)
end

function M.setup()
    init_theme()

    -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
    screen.connect_signal("property::geometry", M.set_wallpaper)
end

return M
