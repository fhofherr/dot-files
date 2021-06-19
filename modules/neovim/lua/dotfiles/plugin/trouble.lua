local M = {}

local trouble = require("trouble")
local wk = require("dotfiles.plugin.which-key")

function M.config()
    trouble.setup()
        wk.register({
            ["<localleader>x"] = {
                name = "Trouble",
                x = { "<cmd>TroubleToggle<cr>", "Toggle diagnostics." },
                w = { "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "Toggle workspace diagnostics." },
                d = { "<cmd>TroubleToggle lsp_document_diagnostics<cr>", "Toggle document diagnostics." },
                q = { "<cmd>TroubleToggle quickfix<cr>", "Toggle quickfix items." },
                l = { "<cmd>TroubleToggle loclist<cr>", "Toggle loclist items." },
            }
        }, { noremap = true, silent = true })
end

return M
