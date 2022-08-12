local M = {
	server_name = "hls",
}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")

function M.setup(opts)
	if vim.fn.executable("haskell-language-server-wrapper") ~= 1 then
		return
	end
	lspconfig.hls.setup(opts)
end

return M
