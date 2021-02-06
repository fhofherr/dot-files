local M = {}

local plugin = require("dotfiles.plugin")
local treesitter = plugin.safe_require("nvim-treesitter")
local treesitter_configs = plugin.safe_require("nvim-treesitter.configs")

function M.setup()
    if not treesitter then
        return
    end

    treesitter_configs.setup {
        highlight = { enable = false },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                node_decremental = "grm",
                scope_incremental = "grc",
            },
        },
        indent = {
            enable = true,
            disable = {
                "go",  -- Gopls/goimports does that for us.
                "python", -- Doesn't work currently: https://github.com/nvim-treesitter/nvim-treesitter/issues/802
            },
        },
        refactor = {
            highlight_definitions = { enable = true },
            smart_rename = {
                enable = true,
                disable = { "go", "python" }, -- We use the language server for that
                keymaps = {
                    smart_rename = "<F2>"
                },
            },
        },
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["ab"] = "@block.outer",
                    ["ib"] = "@block.inner",
                    ["ac"] = "@comment.outer",
                    ["ic"] = "@comment.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ap"] = "@parameter.outer",
                    ["ip"] = "@parameter.inner",
                },
            },
        },
        ensure_installed = "maintained",
    }

    vim.api.nvim_command([[
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
    ]])
end

function M.status()
    if not treesitter then
        return ""
    end
    local ok, statusline = pcall(treesitter.statusline,15)
    if not ok or not statusline then
        return ""
    end
    return statusline
end

return M
