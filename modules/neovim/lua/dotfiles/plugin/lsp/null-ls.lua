local M = {}

local plugin = require("dotfiles.plugin")
local null_ls = require("null-ls")
local builtins = null_ls.builtins

local sources = {
	builtins.code_actions.gitsigns,
	builtins.code_actions.shellcheck,

	builtins.diagnostics.ansiblelint.with({
		condition = function()
			return vim.fn.executable("ansible-lint") == 1
		end,
	}),
	builtins.diagnostics.buf,
	-- builtins.diagnostics.checkmake, -- TODO install checkmake: https://github.com/mrtazz/checkmake
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
	builtins.diagnostics.revive.with({
		args = function()
			local revive_args = { "-formatter", "json" }
			local cfg_files = { "revive.toml", ".revive.toml" }

			for _, file in ipairs(cfg_files) do
				if vim.fn.filereadable(file) == 1 then
					table.insert(revive_args, "-config")
					table.insert(revive_args, file)
					break
				end
			end
			table.insert(revive_args, "./...")

			return revive_args
		end,
	}),
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

function M.setup(opts)
	opts.sources = sources
	null_ls.setup(opts)
end

return M
