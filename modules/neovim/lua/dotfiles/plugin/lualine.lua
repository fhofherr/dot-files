local M = {}

local plugin = require("dotfiles.plugin")
local lualine = require("lualine")

local function select_theme()
    local color_schemes = {
        dracula = "dracula",
        ["everforest-dark-hard"] = "everforest",
        ["everforest-dark-medium"] = "everforest",
        ["everforest-dark-soft"] = "everforest",
        ["everforest-light-hard"] = "everforest",
        ["everforest-light-medium"] = "everforest",
        ["everforest-light-soft"] = "everforest",
        ["iceberg-dark"] = "iceberg_dark",
        ["iceberg-light"] = "iceberg_light",
        ["gruvbox-dark"] = "gruvbox",
        ["gruvbox-light"] = "gruvbox_light",
        ["onehalf-dark"] = "onedark",
        ["onehalf-light"] = "onelight",
    }
    return color_schemes[vim.env.DOTFILES_COLOR_SCHEME] or "gruvbox"
end

local function select_extensions()
    local extensions = {}

    if plugin.exists("fugitive") then
        extensions[#extensions+1] = "fugitive"
    end
    return extensions
end

function M.config()
    lualine.setup({
        options = {
            theme = select_theme(),
            icons_enabled = true,
        },
        sections = {
            lualine_a = {"mode"},
            lualine_b = {"branch"},
            lualine_c = {"filename"},
            lualine_x = {
                {"diagnostics", sources = {"nvim_lsp", "ale"}},
                "encoding",
                "fileformat",
                "filetype",
            },
            lualine_y = {"progress"},
            lualine_z = {"location"}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {"filename"},
            lualine_x = {"location"},
            lualine_y = {},
            lualine_z = {}
        },
        extensions = select_extensions(),
    })
end

return M
