local M = {}

local lspconfig = require("lspconfig")
local clangd_exts = require("clangd_extensions")
local ccls = require("dotfiles.plugin.lsp.ccls")

function M.enabled()
	return vim.fn.executable("clangd") == 1 and not ccls.enabled()
end

function M.setup(opts)
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
	clangd_exts.setup({
		server = opts,
	})
end

return M
