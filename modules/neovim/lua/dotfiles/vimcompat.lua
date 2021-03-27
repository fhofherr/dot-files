local M = {}

local plugin = require("dotfiles.plugin")
local npairs = plugin.safe_require("nvim-autopairs")

function M.termesc(str)
    if npairs then
        return npairs.esc(str)
    end
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

return M
