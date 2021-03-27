local M = {}

local plugin = require("dotfiles.plugin")
local npairs = plugin.safe_require("nvim-autopairs")

function M.setup()
    if not npairs then
        return
    end
    return npairs.setup()
end

return M
