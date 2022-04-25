local M = {}

local plugin = require("dotfiles.plugin")
local null_ls = require("null-ls")
local builtins = null_ls.builtins

local defaults = require("dotfiles.plugin.lsp.defaults")

local sources = {
	builtins.code_actions.gitsigns,
	builtins.code_actions.shellcheck,

	builtins.diagnostics.ansiblelint,
	builtins.diagnostics.buf,
	builtins.diagnostics.checkmake, -- TODO install checkmake: https://github.com/mrtazz/checkmake
	builtins.diagnostics.flake8.with({
		condition = function()
			return vim.fn.executable("flake8") == 1
		end,
	}),
	builtins.diagnostics.gitlint,
	builtins.diagnostics.golangci_lint,
	builtins.diagnostics.luacheck.with({
		command = plugin.hererocks_bin() .. "/luacheck",
		cwd = function()
			local rc = vim.fn.getcwd(0) .. "/.luacheckrc"
			if vim.fn.filereadable(rc) > 0 then
				return rc
			end
		end,
	}),
	builtins.diagnostics.mypy.with({
		condition = function()
			return vim.fn.executable("mypy") == 1
		end,
	}),
	builtins.diagnostics.revive,
	builtins.diagnostics.shellcheck,
	builtins.diagnostics.yamllint,

	builtins.formatting.black.with({
		condition = function()
			return vim.fn.executable("black") == 1
		end,
	}),
	builtins.formatting.buf,
	builtins.formatting.clang_format,
	builtins.formatting.isort.with({
		condition = function()
			return vim.fn.executable("isort") == 1
		end,
	}),
	builtins.formatting.shfmt,
	builtins.formatting.stylua,
}

function M.setup()
	local opts = defaults.new_defaults()

	opts.sources = sources
	null_ls.setup(opts)
end

return M
