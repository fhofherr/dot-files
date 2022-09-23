local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")

function M.setup(opts)
	lspconfig.bufls.setup(opts)
end

return M
