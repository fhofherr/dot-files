local M = {}

local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local wk = require("dotfiles.plugin.which-key")

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
	-- -- FZY extension does not work on all machines (e.g. raspberry pi)
	-- if vim.tbl_contains({"fhhc", "wintermute"}, vim.fn.hostname()) then
	--     telescope.load_extension('fzy_native')
	-- end

	wk.register({
		name = "Telescope",
		["<C-p>"] = { "<cmd>lua require('dotfiles.plugin.telescope').find_files()<CR>", "Find files" },
		["<localleader>e"] = {
			"<cmd>lua require('dotfiles.plugin.telescope').file_browser()<CR>",
			"Browse current working directory.",
		},
		["<localleader>E"] = {
			"<cmd>lua require('dotfiles.plugin.telescope').file_browser({cwd=vim.fn.expand('%:p:h')})<CR>",
			"Browse current file directory.",
		},
		["<localleader>f"] = {
			name = "Find",
			b = { "<cmd>lua require('dotfiles.plugin.telescope').buffers()<CR>", "Find buffers." },
			f = { "<cmd>lua require('dotfiles.plugin.telescope').find_files()<CR>", "Find files." },
			g = { "<cmd>lua require('dotfiles.plugin.telescope').live_grep()<CR>", "Live grep." },
			h = { "<cmd>lua require('dotfiles.plugin.telescope').help_tags()<CR>", "Live grep." },
			l = { "<cmd>lua require('dotfiles.plugin.telescope').loclist()<CR>", "Find tags." },
			m = { "<cmd>lua require('dotfiles.plugin.telescope').marks()<CR>", "Find marks." },
			o = { "<cmd>lua require('dotfiles.plugin.telescope').oldfiles()<CR>", "Recently opened files" },
			q = { "<cmd>lua require('dotfiles.plugin.telescope').quickfix()<CR>", "Find tags." },
			r = { "<cmd>lua require('dotfiles.plugin.telescope').registers()<CR>", "Find tags." },
			s = {
				"<cmd>lua require('dotfiles.plugin.telescope').document_symbols()<CR>",
				"Find LSP/Treesitter symbols.",
			},
			t = { "<cmd>lua require('dotfiles.plugin.telescope').workspace_symbols()<CR>", "Find tags." },
			j = { "<cmd>lua require('dotfiles.plugin.telescope').jumplist()<CR>", "Find jumlist entry" },
		},
	}, {
		noremap = true,
		silent = true,
	})
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

M.file_browser = builtin.file_browser
M.help_tags = builtin.help_tags
M.jumplist = builtin.jumplist
M.live_grep = builtin.live_grep
M.loclist = builtin.loclist
M.marks = builtin.marks
M.oldfiles = builtin.oldfiles
M.quickfix = builtin.quickfix
M.registers = builtin.registers
M.tags = builtin.tags

function M.document_symbols()
	-- Check if buffer is attached to *any* lsp client. Usually this is just
	-- one. If this is the case use the language server to obtain the document
	-- symbols. Fall back to treesitter otherwise.

	local lsp_clients = vim.lsp.buf_get_clients(0)
	if not vim.tbl_isempty(lsp_clients) then
		return builtin.lsp_document_symbols()
	end
	return builtin.treesitter()
end

function M.workspace_symbols()
	-- Check if buffer is attached to *any* lsp client. Usually this is just
	-- one. If this is the case, and none of the clients is in the block list
	-- use the language server to obtain the workspace symbols.
	-- Fall back to ctags otherwise.
	local blocked = {
		"gopls", -- Does not return anything on document_symbols
	}

	local lsp_clients = vim.lsp.buf_get_clients(0)
	local use_lsp = not vim.tbl_isempty(lsp_clients)
	local has_workspace_symbols = false

	for _, v in pairs(lsp_clients) do
		if vim.tbl_contains(blocked, v.name) then
			use_lsp = false
			break
		end
		has_workspace_symbols = has_workspace_symbols or v.resolved_capabilities.workspace_symbol
	end
	if use_lsp and has_workspace_symbols then
		return builtin.lsp_workspace_symbols()
	end
	return builtin.tags()
end

function M.find_files()
	local opts = {
		shorten_path = false,
	}
	local ok = pcall(builtin.git_files, opts)
	if not ok then
		builtin.find_files(opts)
	end
end

function M.lsp_code_actions()
	if not builtin then
		return vim.lsp.buf_code_action()
	end
	local opts = themes.get_dropdown({
		winblend = 10,
		border = true,
		previewer = false,
		shorten_path = false,
	})
	return builtin.lsp_code_actions(opts)
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
