local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")

local M = {}

function M.setup(opts)
	-- pamac install pyright
	if vim.fn.executable("pyright-langserver") ~= 1 then
		return
	end
	lspconfig.pyright.setup(opts)
end

return M
