local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local defaults = require("dotfiles.plugin.lsp.defaults")

function M.setup()
    local pyls_opts = defaults.new_defaults()
    lspconfig.pylsp.setup(pyls_opts)
end

return M
