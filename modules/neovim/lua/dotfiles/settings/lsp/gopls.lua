local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local defaults = require("dotfiles.settings.lsp.defaults")

local function build_flags()
    local flags = {}

    local tags = vim.env.GOPLS_BUILD_TAGS
    if tags and tags ~= "" then
        flags[#flags+1] = "-tags"
        flags[#flags+1] = tags
    end

    return flags
end

function M.setup()
    local gopls_opts = defaults.new_defaults()

    gopls_opts.cmd = {"gopls", "--remote=auto"}
    gopls_opts.init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        buildFlags = build_flags(),
    }
    gopls_opts.capabilities.textDocument.completion.completionItem.snippetSupport = true

    lspconfig.gopls.setup(gopls_opts)
end

return M
