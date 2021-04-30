local M = {}

local plugin = require("dotfiles.plugin")
local wk = plugin.safe_require("which-key")

function M.setup()
    if not wk then
        return
    end
    wk.setup()
end

if wk then
    M.register = wk.register
else
    M.regsister = function()
        -- Do nothing
    end
end

return M
