local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local defaults = require("dotfiles.plugin.lsp.defaults")

function M.setup()
    local ccls_opts = defaults.new_defaults()

    ccls_opts.root_dir = lspconfig.util.root_pattern("compile_commands.json", ".ccls", "compile_flags.txt")
    if vim.g.dotfiles_lsp_ccls_root_patterns then
        ccls_opts.root_dir = lspconfig.util.root_pattern(vim.g.dotfiles_lsp_ccls_root_patterns)
    end
    lspconfig.ccls.setup(ccls_opts)
end

return M
