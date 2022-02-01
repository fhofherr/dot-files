local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local defaults = require("dotfiles.plugin.lsp.defaults")

local M = {}

function M.setup()
    -- pamac install pyright
    if vim.fn.executable("pyright-langserver") ~= 1 then
        return
    end

    local opts = defaults.new_defaults()
    lspconfig.pyright.setup(opts)
end

return M
