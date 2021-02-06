local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local lsp_status = plugin.safe_require("lsp-status")

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

    if lsp_status then
        lsp_status.register_progress()
    end

    if lspconfig then
        for _, v in pairs(language_servers) do
            v.setup()
        end
    end
end

function M.status()
    -- TODO have a look at the file mentioned in
    -- https://github.com/nvim-lua/lsp-status.nvim#lsp-statusline-segment and
    -- develop a custom status line segment.
    if lsp_status and #vim.lsp.buf_get_clients() > 0  then
        return lsp_status.status()
    end
    if #vim.lsp.buf_get_clients() > 0 then
        return "LSP"
    end
    return "NO LSP"
end

return M
