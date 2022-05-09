local M = {}

local lspconfig = require("lspconfig")
local mappings = require("dotfiles.mappings")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local aerial = require("aerial")

local language_servers = {
	clangd = require("dotfiles.plugin.lsp.clangd"),
	gopls = require("dotfiles.plugin.lsp.gopls"),
	pylsp = require("dotfiles.plugin.lsp.pylsp"),
	pyright = require("dotfiles.plugin.lsp.pyright"),
	sumneko_lua = require("dotfiles.plugin.lsp.lualsp"),
	yamlls = require("dotfiles.plugin.lsp.yamlls"),
	null_ls = require("dotfiles.plugin.lsp.null-ls"),
}

local preferred_formatters = {
	gopls = "go",
	clangd = { "c", "cpp" },
}

local function configure_buffer(_, bufnr)
	vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
end

local function configure_formatting(_, bufnr)
	-- Abort if the autocmd was already created for the buffer.
	if vim.b.dotfiles_lspfmt_autocmd then
		return
	end

	local formatters_by_filetype = {}
	for ls_name, fts in pairs(preferred_formatters) do
		if type(fts) == "string" then
			formatters_by_filetype[fts] = ls_name
		else
			for _, ft in ipairs(fts) do
				formatters_by_filetype[ft] = ls_name
			end
		end
	end

	local can_fmt = function(c)
		return c.server_capabilities.documentFormattingProvider or c.server_capabilities.documentRangeFormattingProvider
	end

	local filter_clients = function(clients)
		local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
		local preferred_client = formatters_by_filetype[ft]
		local filtered_clients = nil

		for _, c in ipairs(clients) do
			if preferred_client == c.name then
				-- Found the preferred client. No need to look further.
				filtered_clients = { c }
				break
			elseif c.name == "null-ls" and can_fmt(c) then
				-- We found null-ls but it may not be the preferred client.
				-- Therefore we need to look further.
				filtered_clients = { c }
			end
		end

		if filtered_clients ~= nil then
			return filtered_clients
		end

		-- Let neovim sort out which client to use.
		return clients
	end

	local do_fmt = function()
		vim.lsp.buf.format({
			filter = filter_clients,
			bufnr = bufnr,
			async = false,
		})
	end

	-- Remember the id of the autocmd. This is not really used but allows
	-- is to not attach the auto command again to the buffer.
	vim.b.dotfiles_lspfmt_autocmd = vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = do_fmt,
	})

	vim.api.nvim_buf_create_user_command(bufnr, "LspFmt", do_fmt, {})
end

local function new_default_opts()
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
	return {
		on_attach = function(client, bufnr)
			configure_buffer(client, bufnr)
			configure_formatting(client, bufnr)
			aerial.on_attach(client, bufnr)
			mappings.on_lsp_attached(bufnr)
		end,
		capabilities = capabilities,
	}
end

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
			v.setup(new_default_opts())
		end
	end
end

return M
