local M = {}

local plugin = require("dotfiles.plugin")
local wk = require("dotfiles.settings.which-key")


function M.setup()
    if not plugin.exists("neoterm") then
        return
    end
    vim.g.neoterm_autoinsert = 0
    vim.g.neoterm_autojump = 0
    vim.g.neoterm_callbacks = {
        before_new = function()
            if vim.fn.winwidth(".") > 100 then
                vim.g.neoterm_default_mod = "botright vertical"
            else
                vim.g.neoterm_default_mod = "botright"
            end
        end
    }

    vim.api.nvim_command("command! Term :Topen")
    vim.api.nvim_command("command! STerm :belowright :Topen")
    vim.api.nvim_command("command! VTerm :vertical :Topen")
    vim.api.nvim_command("command! TTerm :tab :Topen")

    wk.register({
        ["<localleader>T"] = {
            name="Terminal",
            e = {"<cmd>Term<cr>", "Create a terminal in the default orientation."},
            s = {"<cmd>STerm<cr>", "Create a terminal in a horizontal split."},
            v = {"<cmd>STerm<cr>", "Create a terminal in a vertical split."},
        },
    }, { noremap = true, silent = true })
end

return M
