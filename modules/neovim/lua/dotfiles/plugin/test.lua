local M = {}

local plugin = require("dotfiles.plugin")
local wk = require("dotfiles.plugin.which-key")

function M.config()
    if plugin.exists("vim-dispatch") then
        vim.g["test#strategy"] = "dispatch"
    end
    vim.g["test#preserve_screen"] = 1
    vim.g["test#go#gotest#options"] = "-timeout 30s"

    wk.register({
        ["<localleader>t"] = {
            name = "Test",
            n = { "<cmd>:TestNearest<CR>", "Run nearest test." },
            f = { "<cmd>:TestFile<CR>", "Run all tests in file." },
            s = { "<cmd>:TestSuite<CR>", "Run test suite." },
            l = { "<cmd>:TestLast<CR>", "Re-run last test." },
            v = { "<cmd>:TestVisit<CR>", "Open last run test." },
        },
    }, { noremap = true, silent = true })
end

return M
