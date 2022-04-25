local M = {}

local plugin = require("dotfiles.plugin")
local telescope = require("dotfiles.plugin.telescope")
local luasnip = require("dotfiles.plugin.luasnip")

function M.register()
	local opts = { silent = true }
	--
	-- Code navigation
	--
	-- Toggle code outline
	vim.keymap.set("n", "<localleader>o", "<cmd>:AerialToggle!<CR>", opts)

	--
	-- Diagnostics
	--
	vim.keymap.set("n", "]w", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "[w", vim.diagnostic.goto_prev, opts)

	-- Show document diagnostics
	vim.keymap.set("n", "<localleader>xd", telescope.document_diagnostics, opts)
	-- Show workspace diagnostics
	vim.keymap.set("n", "<localleader>xw", telescope.workspace_diagnostics, opts)

	--
	-- Searching and finding
	--
	vim.keymap.set("n", "<C-p>", telescope.find_files, opts) -- Find files.
	vim.keymap.set("n", "<localleader>fb", telescope.buffers, opts) -- Find buffers.
	vim.keymap.set("n", "<localleader>ff", telescope.find_files, opts) -- Find files.
	vim.keymap.set("n", "<localleader>fg", telescope.live_grep, opts) -- Live grep.
	vim.keymap.set("n", "<localleader>fh", telescope.help_tags, opts) -- Search help.
	vim.keymap.set("n", "<localleader>fl", telescope.loclist, opts) -- Find tags.
	vim.keymap.set("n", "<localleader>fm", telescope.marks, opts) -- Find marks.
	vim.keymap.set("n", "<localleader>fo", telescope.oldfiles, opts) -- Recently opened files
	vim.keymap.set("n", "<localleader>fq", telescope.quickfix, opts) -- Find tags.
	vim.keymap.set("n", "<localleader>fr", telescope.registers, opts) -- Find tags.
	vim.keymap.set("n", "<localleader>fs", telescope.document_symbols, opts) -- Find LSP/Treesitter symbols.
	vim.keymap.set("n", "<localleader>ft", telescope.workspace_symbols, opts) -- Find tags.
	vim.keymap.set("n", "<localleader>fj", telescope.jumplist, opts) -- Find jumlist entry

	--
	-- File browsing
	--
	-- Browse current working directory
	vim.keymap.set("n", "<localleader>e", telescope.file_browser, opts)

	-- Browse current file directory
	vim.keymap.set("n", "<localleader>E", function()
		telescope.file_browser({ cwd = vim.fn.expand("%:p:h", opts) })
	end)

	-- Toggle NeoTree filesystem
	vim.keymap.set(
		"n",
		"<localleader>nt",
		"<cmd>:Neotree reveal=true toggle=true position=left source=filesystem<CR>",
		opts
	)

	--
	-- Snippets
	--
	vim.keymap.set({ "i", "s" }, "<c-j>", luasnip.expand_or_jump)
	vim.keymap.set({ "i", "s" }, "<c-k>", luasnip.jump_back)
	vim.keymap.set({ "i", "s" }, "<c-l>", luasnip.select_choice)

	--
	-- Testing
	--
	if plugin.exists("vim-ultest") then
		vim.keymap.set("n", "<localleader>tf", "<Plug>(ultest-run-file)", opts) -- Run all tests in file.
		vim.keymap.set("n", "<localleader>tn", "<Plug>(ultest-run-nearest)", opts) -- Run nearest test.
		vim.keymap.set("n", "<localleader>to", "<Plug>(ultest-output-jump)", opts) -- Show error output of nearest test
		vim.keymap.set("n", "<localleader>ts", "<Plug>(ultest-summary-toggle)", opts) -- Toggle test summary
	else
		vim.keymap.set("n", "<localleader>tn", "<cmd>:TestNearest<CR>", opts) -- Run nearest test.
		vim.keymap.set("n", "<localleader>tf", "<cmd>:TestFile<CR>", opts) -- Run all tests in file.
	end

	--
	-- Window navigation
	--
	if plugin.exists("Navigator.nvim") then
		vim.keymap.set("n", "<C-J>", "<CMD>lua require('Navigator').down()<CR>", opts) -- Move one window down
		vim.keymap.set("n", "<C-K>", "<CMD>lua require('Navigator').up()<CR>", opts) -- Move one window up
		vim.keymap.set("n", "<C-L>", "<CMD>lua require('Navigator').right()<CR>", opts) -- Move one window right
		vim.keymap.set("n", "<C-H>", "<CMD>lua require('Navigator').left()<CR>", opts) -- Move one window left
	else
		vim.keymap.set("n", "<C-J>", "<C-W><C-J>", opts) -- Move one window down
		vim.keymap.set("n", "<C-K>", "<C-W><C-K>", opts) -- Move one window up
		vim.keymap.set("n", "<C-L>", "<C-W><C-L>", opts) -- Move one window right
		vim.keymap.set("n", "<C-H>", "<C-W><C-H>", opts) -- Move one window left
	end

	--
	-- Various editing helpers
	--
	vim.keymap.set("n", "<", "<gv", opts) -- Decrease indent and reselect
	vim.keymap.set("n", ">", ">gv", opts) -- Increase indent and reselect
end

function M.on_lsp_attached(bufnr)
	local opts = { silent = true, buffer = bufnr }

	vim.keymap.set("n", "gD", telescope.lsp_type_definitions, opts) -- Go to type definition.
	vim.keymap.set("n", "gd", telescope.lsp_definitions, opts) -- Go to definition.
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- Show documentation
	vim.keymap.set("n", "gi", telescope.lsp_implementations, opts) -- Go to implementation
	vim.keymap.set("n", "gr", telescope.lsp_references, opts) -- Show references
	vim.keymap.set("n", "<c-s>", vim.lsp.buf.signature_help, opts) -- Show signature.
	vim.keymap.set("n", "1gD", vim.lsp.buf.declaration, opts) -- Go to declaration.
	vim.keymap.set("n", "<localleader>rn", vim.lsp.buf.rename, opts) -- Rename symbol
	vim.keymap.set("n", "<localleader>ca", telescope.lsp_code_actions, opts) -- Show code actions
end

function M.on_gitsigns_attach(bufnr)
	local opts = { silent = true, buffer = bufnr }
	local range = function()
		local start = vim.fn.line("v")
		local stop = vim.fn.line(".")

		vim.api.nvim_input("<esc>") -- Not sure if I should be doing this here

		if start <= stop then
			return { start, stop }
		else
			return { stop, start }
		end
	end

	local gs = require("gitsigns")

	-- Stage a hunk
	vim.keymap.set("n", "<localleader>ghs", gs.stage_hunk, opts)
	vim.keymap.set("v", "<localleader>ghs", function()
		return gs.stage_hunk(range())
	end, opts)

	-- Stage a hunk
	vim.keymap.set("n", "<localleader>ghu", gs.undo_stage_hunk, opts)
	vim.keymap.set("v", "<localleader>ghu", function()
		gs.undo_stage_hunk(range())
	end, opts)

	-- Reset a hunk
	vim.keymap.set("n", "<localleader>ghr", gs.reset_hunk, opts)
	vim.keymap.set("v", "<localleader>ghr", function()
		gs.reset_hunk(range())
	end, opts)
end

return M
