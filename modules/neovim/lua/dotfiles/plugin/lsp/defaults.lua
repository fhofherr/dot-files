local M = {}

local plugin = require("dotfiles.plugin")
local mappings = require("dotfiles.mappings")

local cmp_nvim_lsp = plugin.safe_require("cmp_nvim_lsp")
local aerial = require("aerial")

local function on_attach(client, bufnr)
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end
	local function buf_def_cmd(name, rhs)
		vim.api.nvim_command("command! -buffer " .. name .. " " .. rhs)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Define buffer local commands
	buf_def_cmd("LspRename", "lua vim.lsp.buf.rename()")
	buf_def_cmd("LspIncomingCalls", "lua vim.lsp.buf.incoming_calls()")
	buf_def_cmd("LspOutgoingCalls", "lua vim.lsp.buf.outgoing_calls()")
	buf_def_cmd("LspCodeActions", "lua require('dotfiles.plugin.telescope').lsp_code_actions()")

	if client.resolved_capabilities.document_formatting or client.resolved_capabilities.document_range_formatting then
		buf_def_cmd("LspFmt", "lua vim.lsp.buf.formatting()")
		vim.api.nvim_command("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	end

    aerial.on_attach(client, bufnr)

	mappings.on_lsp_attached(bufnr)
	vim.b.dotfiles_lsp_enabled = 1
end

function M.new_defaults()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	if cmp_nvim_lsp then
		capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
	end
	local opts = {
		on_attach = on_attach,
		capabilities = capabilities,
	}
	return opts
end

return M
