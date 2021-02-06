local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local defaults = require("dotfiles.settings.lsp.defaults")

function M.setup()
    local gopls_opts = defaults.new_defaults()

    gopls_opts.cmd = {"gopls", "--remote=auto"}
    gopls_opts.init_options = {
        usePlaceholders = true,
        completeUnimported = true,
    }
    gopls_opts.capablities = defaults.extend_capabilities(gopls_opts.capabilities, {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = false
                }
            }
        }
    })

    lspconfig.gopls.setup(gopls_opts)
end

return M
