local M = {}

local plugin = require("dotfiles.plugin")
local cmp_nvim_lsp = plugin.safe_require("cmp_nvim_lsp")
local wk = require("dotfiles.plugin.which-key")
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
	wk.register({
		name = "lsp",
		gD = {
			"<cmd>lua require('dotfiles.plugin.telescope').lsp_type_definitions()<CR>",
			"Go to type definition.",
		},
		gd = { "<cmd>lua require('dotfiles.plugin.telescope').lsp_definitions()<CR>", "Go to definition." },
		K = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show documentation." },
		gi = { "<cmd>lua require('dotfiles.plugin.telescope').lsp_implementations()<CR>", "Go to implementation." },
		["<c-s>"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Show signature." },
		["1gD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration." },
		gr = { "<cmd>lua require('dotfiles.plugin.telescope').lsp_references()<CR>", "Show references." },
	}, {
		noremap = true,
		silent = true,
		buffer = bufnr,
	})

	wk.register({
		name = "lsp",
		rn = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol." },
		ca = { "<cmd>lua require('dotfiles.plugin.telescope').lsp_code_actions()<CR>", "Show code actions" },
	}, {
		noremap = true,
		silent = true,
		buffer = bufnr,
		prefix = "<localleader>",
	})

	buf_def_cmd("LspRename", "lua vim.lsp.buf.rename()")
	buf_def_cmd("LspIncomingCalls", "lua vim.lsp.buf.incoming_calls()")
	buf_def_cmd("LspOutgoingCalls", "lua vim.lsp.buf.outgoing_calls()")
	buf_def_cmd("LspCodeActions", "lua require('dotfiles.plugin.telescope').lsp_code_actions()")

	if client.resolved_capabilities.document_formatting or client.resolved_capabilities.document_range_formatting then
		buf_def_cmd("LspFmt", "lua vim.lsp.buf.formatting()")
		vim.api.nvim_command("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
	end

    aerial.on_attach(client, bufnr)

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
