local M = {}

local plugin = require("dotfiles.plugin")
local wk = require("dotfiles.plugin.which-key")

function M.config()
    if plugin.exists("vim-dispatch") then
        vim.g["test#strategy"] = "dispatch"
    end
    if plugin.exists("vim-ultest") then
        vim.g.ultest_use_pty = 1
        wk.register({
            ["<localleader>t"] = {
                name = "Test",
                n = { "<cmd>:UltestNearest<CR>", "Run nearest test." },
                f = { "<cmd>:Ultest<CR>", "Run all tests in file." },
            },
        }, { noremap = true, silent = true })
    else
        wk.register({
            ["<localleader>t"] = {
                name = "Test",
                n = { "<cmd>:TestNearest<CR>", "Run nearest test." },
                f = { "<cmd>:TestFile<CR>", "Run all tests in file." },
            },
        }, { noremap = true, silent = true })
    end
    vim.g["test#preserve_screen"] = 1
    vim.g["test#go#gotest#options"] = "-timeout 30s"


end

return M
