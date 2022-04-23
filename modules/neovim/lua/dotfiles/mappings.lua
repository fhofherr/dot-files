local M = {}

local wk = require("which-key")
local plugin = require("dotfiles.plugin")

local normal_mode = { mode = "n", noremap = true, silent = true }
local visual_mode = { mode = "v", noremap = true, silent = true }

function M.register()
	wk.register({
		["]w"] = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Go to next LSP diagnostic" },
		["[w"] = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to next LSP diagnostic" },
		["<C-p>"] = { "<cmd>lua require('dotfiles.plugin.telescope').find_files()<CR>", "Find files" },
		Q = { ":bdelete<cr>", "Delete Buffer" },

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

		["<localleader>n"] = {
			name = "NeoTree",
			t = {
				"<cmd>:Neotree reveal=true toggle=true position=left source=filesystem<CR>",
				"Toggle NeoTree filesystem",
			},
			b = {
				"<cmd>:Neotree reveal=true toggle=true position=right source=buffers<CR>",
				"Toggle NeoTree buffers",
			},
			g = {
				"<cmd>:Neotree reveal=true toggle=true position=float source=git_status<CR>",
				"Toggle NeoTree git status",
			},
		},

		["<localleader>o"] = { "<cmd>:AerialToggle!<CR>", "Toggle code outline" },
		["<localleader>x"] = {
			name = "Trouble",
			d = {
				"<cmd>lua require('dotfiles.plugin.telescope').document_diagnostics()<CR>",
				"Toggle document diagnostics",
			},
			w = {
				"<cmd>lua require('dotfiles.plugin.telescope').workspace_diagnostics()<CR>",
				"Toggle workspace diagnostics",
			},
		},
	}, normal_mode)

	if plugin.exists("vim-ultest") then
		wk.register({
			["<localleader>t"] = {
				name = "Test",
				f = { "<Plug>(ultest-run-file)", "Run all tests in file." },
				n = { "<Plug>(ultest-run-nearest)", "Run nearest test." },
				o = { "<Plug>(ultest-output-jump)", "Show error output of nearest test" },
				s = { "<Plug>(ultest-summary-toggle)", "Toggle test summary" },
			},
		}, normal_mode)
	else
		wk.register({
			["<localleader>t"] = {
				name = "Test",
				n = { "<cmd>:TestNearest<CR>", "Run nearest test." },
				f = { "<cmd>:TestFile<CR>", "Run all tests in file." },
			},
		}, normal_mode)
	end

	if plugin.exists("Navigator.nvim") then
		wk.register({
			["<C-J>"] = { "<CMD>lua require('Navigator').down()<CR>", "One window down" },
			["<C-K>"] = { "<CMD>lua require('Navigator').up()<CR>", "One window up" },
			["<C-L>"] = { "<CMD>lua require('Navigator').right()<CR>", "One window right" },
			["<C-H>"] = { "<CMD>lua require('Navigator').left()<CR>", "One window left" },
		}, normal_mode)
	else
		wk.register({
			["<C-J>"] = { "<C-W><C-J>", "One window down" },
			["<C-K>"] = { "<C-W><C-K>", "One window up" },
			["<C-L>"] = { "<C-W><C-L>", "One window right" },
			["<C-H>"] = { "<C-W><C-H>", "One window left" },
		}, normal_mode)
	end

	wk.register({
		["<"] = { "<gv", "Decrease indent and reselect" },
		[">"] = { ">gv", "Increase indent and reselect" },
	}, visual_mode)
end

function M.on_lsp_attached(bufnr)
	local normal_mode_buffer = vim.deepcopy(normal_mode)
	normal_mode_buffer.buffer = bufnr

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

		["<localleader>"] = {
			rn = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename symbol." },
			ca = { "<cmd>lua require('dotfiles.plugin.telescope').lsp_code_actions()<CR>", "Show code actions" },
		},
	}, normal_mode_buffer)
end

return M
