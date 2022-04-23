local M = {}

local plugin = require("dotfiles.plugin")
local lint = require("lint")
local parser = require("lint.parser")

-- List of linters we want to configure. Not all linters may be available
-- on all systems. We therefore check if the command exists before adding
-- the linter to lint.linters_by_ft.
local desired_linters = {
    go = {"golangcilint", "revive"},
    lua = {"luacheck"},
    proto = {"buf"},
    python = {"mypy", "flake8"},
    sh = {"shellcheck"},
}

lint.linters.buf = {
    cmd = "buf",
    stdin = false,
    ignore_exitcode = true,
    args = {"lint", "--path"},
    stream = "stdout",
    parser = parser.from_errorformat("%f:%l:%c:%m"),
}

lint.linters.luacheck.cmd = plugin.hererocks_bin() .. "/luacheck"

local function buf_write_post()
    local linters = lint.linters_by_ft[vim.bo.filetype]
    if not linters then
        return
    end
    lint.try_lint()
end

local function insert_leave()
    local linters = lint.linters_by_ft[vim.bo.filetype]
    if not linters then
        return
    end
    -- Check if at least one of the the linters is capable of reading from
    -- stdin.
    if vim.b.lint_on_insert_leave == nil then
        vim.b.lint_on_insert_leave = false

        for _, name in ipairs(linters) do
            local linter = lint.linters[name]
            if linter and linter.stdin then
                vim.b.lint_on_insert_leave = true
                break
            end
        end
    end
    if vim.b.lint_on_insert_leave then
        lint.try_lint()
    end
end


function M.config()
    for ft, list in pairs(desired_linters) do
        local linters = {}

        for _, x in ipairs(list) do
            local linter = lint.linters[x]
            if linter and vim.fn.executable(linter.cmd) == 1 then
                linters[#linters + 1] = x
            end
        end

        if #linters > 0 then
            lint.linters_by_ft[ft] = linters
        end
    end

	local group = vim.api.nvim_create_augroup("dotfiles_lint", {})
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		callback = buf_write_post,
	})
	vim.api.nvim_create_autocmd("InsertLeave", {
		group = group,
		callback = insert_leave,
	})
end

return M
