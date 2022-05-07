local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")

function M.setup(opts)
	if vim.fn.executable("yaml-language-server") ~= 1 then
		return
	end
	opts.settings = {
		yaml = {
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/json/",
			},
		},
	}
	lspconfig.yamlls.setup(opts)
end

return M
