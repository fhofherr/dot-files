local M = {}

local wk =require("which-key")

function M.config()
    wk.setup()
end

M.register = wk.register

return M
