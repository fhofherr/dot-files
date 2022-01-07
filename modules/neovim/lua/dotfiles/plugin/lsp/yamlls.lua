local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local defaults = require("dotfiles.plugin.lsp.defaults")

function M.setup()
    if vim.fn.executable("yaml-language-server") ~= 1 then
        return
    end
    local opts = defaults.new_defaults()
    opts.settings = {
        yaml = {
            schemaStore = {
                enable = true,
                url = "https://www.schemastore.org/json/",
            },
        },
    }
    lspconfig.yamlls.setup(opts)
end

return M
