local M = {}

local plugin = require("dotfiles.plugin")

function M.config()
    if plugin.exists("vim-dispatch") then
        vim.g["test#strategy"] = "dispatch"
    end
    if plugin.exists("vim-ultest") then
        vim.g.ultest_use_pty = 1
        vim.g.ultest_summary_width = 80
    end
    vim.g["test#preserve_screen"] = 1
    vim.g["test#go#gotest#options"] = "-timeout 30s"
end

return M
