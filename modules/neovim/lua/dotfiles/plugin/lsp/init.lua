local M = {}

local lspconfig = require("lspconfig")

local language_servers = {
	-- ccls = require("dotfiles.plugin.lsp.ccls"),
	clangd = require("dotfiles.plugin.lsp.clangd"),
	gopls = require("dotfiles.plugin.lsp.gopls"),
	pylsp = require("dotfiles.plugin.lsp.pylsp"),
	pyright = require("dotfiles.plugin.lsp.pyright"),
	sumneko_lua = require("dotfiles.plugin.lsp.lualsp"),
	yamlls = require("dotfiles.plugin.lsp.yamlls"),
}

local null_ls = require("dotfiles.plugin.lsp.null-ls")

function M.config()
	-- See :help lsp-handler for more info
	-- See https://github.com/nvim-lua/diagnostic-nvim/issues/73 for transition info from diagnostic-nvim
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = true,
		signs = false,
		update_in_insert = true,
	})

	if lspconfig then
		for _, v in pairs(language_servers) do
			v.setup()
		end
	end
	null_ls.setup()
end

return M
