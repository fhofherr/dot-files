local M = {}

local vimcompat = require("dotfiles.vimcompat")
local plugin = require("dotfiles.plugin")
local lint = require("lint")

-- List of linters we want to configure. Not all linters may be available
-- on all systems. We therefore check if the command exists before adding
-- the linter to lint.linters_by_ft.
local desired_linters = {
    go = {"golangcilint", "revive"},
    lua = {"luacheck"},
    python = {"mypy", "flake8"},
    sh = {"shellcheck"}
}

-- -- TODO configure buf linter: https://github.com/bufbuild/vim-buf/blob/master/ale_linters/proto/buf_lint.vim
lint.linters.luacheck.cmd = plugin.hererocks_bin() .. "/luacheck"

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

    vimcompat.augroup(
        "dotfiles_lint", {
            [[
            BufWritePost * silent lua require("dotfiles.plugin.lint").buf_write_post()
        ]], [[
            InsertLeave * silent lua require("dotfiles.plugin.lint").insert_leave()
        ]]
        }
    )
end

function M.buf_write_post()
    local linters = lint.linters_by_ft[vim.bo.filetype]
    if not linters then
        return
    end
    lint.try_lint()
end

function M.insert_leave()
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

return M
