local M = {}

local lspconfig = require("lspconfig")
local ccls = require("ccls")

function M.enabled()
	return vim.fn.executable("ccls") == 1 and vim.fn.findfile(".ccls", vim.fn.getcwd()) ~= ""
end

function M.setup(opts)
	opts.filetypes = { "c", "cpp", "objc", "objcpp" }
	lspconfig.ccls.setup(opts)
	ccls.setup({
		filetypes = opts.filetypes,
	})
end

return M
