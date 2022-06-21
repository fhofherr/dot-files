local M = {}

local plugin = require("dotfiles.plugin")
local neotest = require("neotest")

function M.config()
	if plugin.exists("vim-dispatch") then
		vim.g["test#strategy"] = "dispatch"
	end
	neotest.setup({
		adapters = {
			require("neotest-go"),
			require("neotest-python")({
				dap = { justMyCode = false },
			}),
			require("neotest-vim-test")({
				ignore_filetypes = { "python", "lua", "go" },
			}),
		},
	})
end

return M
