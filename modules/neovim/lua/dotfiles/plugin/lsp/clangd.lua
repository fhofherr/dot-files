local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local ccls = require("dotfiles.plugin.lsp.ccls")

function M.enabled()
	return not ccls.enabled()
end

function M.setup(opts)
	if vim.fn.executable("clangd") ~= 1 then
		return
	end
	opts.root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
	opts.filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
	opts.cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--cross-file-rename",
		"--header-insertion",
		"never",
		-- "--query-driver",
		-- "/usr/bin/clang-*,/usr/bin/arm-none-eabi-*",
	}
	lspconfig.clangd.setup(opts)
end

return M
