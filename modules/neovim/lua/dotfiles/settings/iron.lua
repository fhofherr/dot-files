local M = {}

local plugin = require("dotfiles.plugin")
local iron = plugin.safe_require("iron")

function M.setup()
    if not iron then
        return
    end

    vim.g.iron_map_defaults = 0
    vim.g.iron_map_extended = 0
    -- TODO add custom mappings that don't clash with existing stuff => maybe try folke/which-key.nvim
end

return M
