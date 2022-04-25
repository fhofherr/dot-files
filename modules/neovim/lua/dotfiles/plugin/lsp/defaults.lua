local M = {}

local plugin = require("dotfiles.plugin")
local mappings = require("dotfiles.mappings")

local cmp_nvim_lsp = plugin.safe_require("cmp_nvim_lsp")
local aerial = require("aerial")

local function configure_buffer(client, bufnr)
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
	buf_def_cmd("LspFmt", "lua vim.lsp.buf.formatting()")
end

local function configure_formatting(client, bufnr)
	local can_fmt = (
		client.resolved_capabilities.document_formatting or client.resolved_capabilities.document_range_formatting
	)
	if not can_fmt then
		return
	end

	-- TODO find a better way!
	-- Having to hard-code the order of the preferred language servers
	-- here is ugly. Additionally it is wasteful to have them all attempt
	-- formatting and throw away most results.
	--
	-- For inspiration see:
	--
	--     * https://github.com/neovim/nvim-lspconfig/wiki/Multiple-language-servers-FAQ#i-see-multiple-formatting-options-and-i-want-a-single-server-to-format-how-do-i-do-this
	local order = { "gopls", "clangd", "null-ls" }
	local group = vim.api.nvim_create_augroup("dotfiles_lsp_formatting", {})
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = group,
		buffer = bufnr,
		callback = function()
			vim.lsp.buf.formatting_seq_sync(nil, nil, order)
		end,
	})
end

function M.new_defaults()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	if cmp_nvim_lsp then
		capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
	end
	local opts = {
		on_attach = function(client, bufnr)
			configure_buffer(client, bufnr)
			configure_formatting(client, bufnr)
			aerial.on_attach(client, bufnr)
			mappings.on_lsp_attached(bufnr)
			vim.b.dotfiles_lsp_enabled = 1
		end,
		capabilities = capabilities,
	}
	return opts
end

return M
