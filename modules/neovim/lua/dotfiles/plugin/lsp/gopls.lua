local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local util = plugin.safe_require("lspconfig.util")

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
		"gopls",
		"serve",
		-- "--remote=auto"
	}
	opts.root_dir = util.root_pattern("go.work", "go.mod", ".git")
	-- See https://github.com/golang/tools/blob/master/gopls/doc/settings.md
	opts.settings = {
		gopls = {
			usePlaceholders = true,
			buildFlags = build_flags(),
			-- See https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
			analyses = {
				fieldalignment = true,
				nilness = true,
				unreachable = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			codelenses = {
				generate = true,
				gc_details = true,
				regenerate_cgo = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = false,
			},
		},
	}

	opts.capabilities.textDocument.completion.completionItem.snippetSupport = true

	lspconfig.gopls.setup(opts)
end

return M
