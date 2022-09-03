local M = {}

local lspconfig = require("lspconfig")

function M.setup(opts)
	lspconfig.ansiblels.setup(opts)
end

return M
