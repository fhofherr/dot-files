local M = {}

local treesitter = require("nvim-treesitter")
local treesitter_configs = require("nvim-treesitter.configs")

function M.config()
	treesitter_configs.setup({
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
        rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = nil,
        },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_incremental = "grn",
				node_decremental = "grm",
				scope_incremental = "grc",
			},
		},
		indent = {
			enable = false,
			disable = {
				"go", -- Gopls/goimports does that for us.
				"python", -- Does not really work as desired.
			},
		},
		playground = {
			enable = true,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
		query_linter = {
			enable = true,
			use_virtual_text = true,
			lint_events = { "BufWrite", "CursorHold" },
		},
		refactor = {
			highlight_definitions = { enable = true },
			highlight_current_scope = { enable = false },
			smart_rename = {
				enable = true,
				disable = { "go", "python" }, -- We use the language server for that
				keymaps = {
					smart_rename = "<leader>rn",
				},
			},
		},
		textobjects = {
			lsp_interop = {
				enable = false,
				peek_definition_code = {
					["<leader>df"] = "@function.outer",
					["<leader>dF"] = "@class.outer",
				},
			},
			move = {
				enable = true,
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["ab"] = "@block.outer",
					["ib"] = "@block.inner",
					["ac"] = "@comment.outer",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
				},
			},
		},
		ensure_installed = "all",
	})

	vim.api.nvim_command([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    ]])
end

function M.status()
	if not treesitter then
		return ""
	end
	local ok, statusline = pcall(treesitter.statusline, 15)
	if not ok or not statusline then
		return ""
	end
	return statusline
end

return M
