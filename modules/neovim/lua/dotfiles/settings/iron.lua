local M = {}

local plugin = require("dotfiles.plugin")
local iron = plugin.safe_require("iron")
local wk = require("dotfiles.settings.which-key")

function M.setup()
    if not iron then
        return
    end

    vim.g.iron_map_defaults = 0
    vim.g.iron_map_extended = 0

    wk.register({
        name = "iron",
        tr = { "<Plug>(iron-send-motion)", "Send chunk of text to REPL." },
        p = { "<Plug>(iron-repeat-cmd)", "Repeat previous command" },
        ["<CR>"] = { "<Plug>(iron-cr)", "Send new line to REPL." },
        st = { "<Plug>(iron-interrupt)", "Send interrupt to REPL." },
        q = { "<Plug>(iron-exit)", "Exit REPL." },
        l = { "<Plug>(iron-clear)", "Clear REPL." },
    }, {prefix="<localleader>c"})
end

return M
