local M = {}

local plugin = require("dotfiles.plugin")
local lualine = plugin.safe_require("lualine")

local function select_theme()
    local color_schemes = {
        dracula = "dracula",
        ["gruvbox-dark"] = "gruvbox",
        ["gruvbox-light"] = "ayu_light", -- TODO currently no gruvbox-light theme available. https://github.com/hoob3rt/lualine.nvim/issues/188
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

function M.setup()
    if not lualine then
        return
    end
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
