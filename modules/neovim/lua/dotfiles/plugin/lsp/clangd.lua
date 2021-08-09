local M = {}

local plugin = require("dotfiles.plugin")
local lspconfig = plugin.safe_require("lspconfig")
local defaults = require("dotfiles.plugin.lsp.defaults")

function M.setup()
    local clangd_opts = defaults.new_defaults()

    clangd_opts.root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")
    clangd_opts.cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--cross-file-rename",
        "--header-insertion", "never",
        "--query-driver", "/usr/bin/clang-*,/usr/bin/arm-none-eabi-*",
    }
    lspconfig.clangd.setup(clangd_opts)
end

return M
