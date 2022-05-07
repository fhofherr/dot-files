local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")

function M.setup(opts)
	lspconfig.pylsp.setup(opts)
end

return M
