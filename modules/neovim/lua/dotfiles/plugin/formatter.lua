local M = {}

local formatter = require("formatter")
local plugin = require("dotfiles.plugin")

-- lua-fmt https://github.com/Koihik/LuaFormatter
local function lua_format()
    return {exe = plugin.hererocks_bin() .. "/lua-format", stdin = true}
end

function M.config()
    formatter.setup({logging = false, filetype = {lua = {lua_format}}})
end

return M
