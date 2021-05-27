local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local lspcolors = plugin.safe_require("lsp-colors")
local lsptrouble = plugin.safe_require("trouble")
local wk = require("dotfiles.settings.which-key")

local language_servers = {
    ccls = require("dotfiles.settings.lsp.ccls"),
    gopls = require("dotfiles.settings.lsp.gopls"),
    pyls = require("dotfiles.settings.lsp.pyls"),
}

function M.setup()
    -- See :help lsp-handler for more info
    -- See https://github.com/nvim-lua/diagnostic-nvim/issues/73 for transition info from diagnostic-nvim
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = false,
            update_in_insert = true,
        }
    )

    if lspconfig then
        for _, v in pairs(language_servers) do
            v.setup()
        end
    end
    if lspcolors then
        lspcolors.setup()
    end
    if lsptrouble then
        lsptrouble.setup()
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
end

return M
