local M = {}

local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

function M.config()
	telescope.setup({
		defaults = {
			layout_config = {
				prompt_position = "top",
			},
			sorting_strategy = "ascending",
			mappings = {
				i = {
					["<C-h>"] = "which_key",
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
				},
				-- fzy_native = {
				--     override_generic_sorter = true,
				--     override_file_sorter = true
				-- }
			},
		},
	})
	telescope.load_extension("fzf")
	telescope.load_extension("file_browser")
	-- -- FZY extension does not work on all machines (e.g. raspberry pi)
	-- if vim.tbl_contains({"fhhc", "wintermute"}, vim.fn.hostname()) then
	--     telescope.load_extension('fzy_native')
	-- end
end

function M.buffers()
	builtin.buffers({
		attach_mappings = function(_, map)
			map("i", "<C-q>", actions.delete_buffer)
			map("n", "<C-q>", actions.delete_buffer)
			return true
		end,
	})
end

M.document_diagnostics = function()
	builtin.diagnostics({ bufnr = 0 })
end
M.file_browser = telescope.extensions.file_browser.file_browser
M.help_tags = builtin.help_tags
M.jumplist = builtin.jumplist
M.live_grep = builtin.live_grep
M.loclist = builtin.loclist
M.marks = builtin.marks
M.oldfiles = builtin.oldfiles
M.quickfix = builtin.quickfix
M.registers = builtin.registers
M.tags = builtin.tags
M.workspace_diagnostics = builtin.diagnostics

function M.document_symbols()
	-- Check if buffer is attached to *any* lsp client.  If this is the case
	-- and at least one of the language servers is a documentSymbolProvider
	-- use the language server to obtain the document symbols.
	-- Fall back to treesitter otherwise.

	local lsp_clients = vim.lsp.buf_get_clients(0)
	for _, c in ipairs(lsp_clients) do
		if c.server_capabilities.documentSymbolProvider then
			return builtin.lsp_document_symbols()
		end
	end
	return builtin.treesitter()
end

function M.workspace_symbols()
	-- Check if *any* active lsp clients exists. If this is the case,
	-- and none of the clients is not in the block list use the
	-- language server to obtain the workspace symbols. Fall back to ctags
	-- otherwise.
	local blocked = {
		"gopls", -- Does not return anything on document_symbols
	}

	local lsp_clients = vim.lsp.get_active_clients()
	local use_lsp = false
	for _, c in ipairs(lsp_clients) do
		if vim.tbl_contains(blocked, c.name) then
			-- Found a blocked client. Whatever we found before does not matter
			-- we use ctags.
			use_lsp = false
			break
		end
		if c.server_capabilities.workspaceSymbolProvider then
			use_lsp = true
		end
	end

	if use_lsp then
		return builtin.lsp_workspace_symbols()
	end
	return builtin.tags()
end

function M.find_files()
	local ok = pcall(builtin.git_files, {
		use_git_root = true,
		show_untracked = true,
	})
	if not ok then
		builtin.find_files({
			shorten_path = false,
		})
	end
end

function M.lsp_code_actions()
	return vim.lsp.buf.code_action()
end

function M.lsp_implementations()
	if not builtin then
		return vim.lsp.buf.implementation()
	end
	return builtin.lsp_implementations()
end

function M.lsp_references()
	if not builtin then
		return vim.lsp.buf.references()
	end
	return builtin.lsp_references()
end

function M.lsp_definitions()
	if not builtin then
		return vim.lsp.buf.definition()
	end
	return builtin.lsp_definitions()
end

function M.lsp_type_definitions()
	if not builtin then
		return vim.lsp.buf.type_definition()
	end
	return builtin.lsp_type_definitions()
end

return M
