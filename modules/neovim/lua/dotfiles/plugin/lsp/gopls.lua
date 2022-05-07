local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")

local function build_flags()
	local flags = {}

	local tags = vim.env.GOPLS_BUILD_TAGS
	if tags and tags ~= "" then
		flags[#flags + 1] = "-tags"
		flags[#flags + 1] = tags
	end

	return flags
end

function M.setup(opts)
	opts.cmd = {
		"gopls", --[["--remote=auto"]]
	}
	opts.init_options = {
		usePlaceholders = true,
		completeUnimported = true,
		buildFlags = build_flags(),
	}
	opts.capabilities.textDocument.completion.completionItem.snippetSupport = true

	lspconfig.gopls.setup(opts)
end

return M
