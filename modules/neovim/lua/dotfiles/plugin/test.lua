local M = {}

local plugin = require("dotfiles.plugin")
local wk = require("dotfiles.plugin.which-key")

function M.config()
    if plugin.exists("vim-dispatch") then
        vim.g["test#strategy"] = "dispatch"
    end
    if plugin.exists("vim-ultest") then
        vim.g.ultest_use_pty = 1
        vim.g.ultest_summary_width = 80

        wk.register({
            ["<localleader>t"] = {
                name = "Test",
                f = { "<Plug>(ultest-run-file)", "Run all tests in file." },
                n = { "<Plug>(ultest-run-nearest)", "Run nearest test." },
                o = { "<Plug>(ultest-output-jump)", "Show error output of nearest test" },
                s = { "<Plug>(ultest-summary-toggle)", "Toggle test summary" },
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
