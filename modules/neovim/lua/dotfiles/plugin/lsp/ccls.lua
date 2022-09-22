local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")

function M.enabled()
	return vim.fn.findfile(".ccls", vim.fn.getcwd()) ~= ""
end

function M.setup(opts)
	if vim.fn.executable("ccls") ~= 1 then
		return
	end
	lspconfig.ccls.setup(opts)
end

return M
