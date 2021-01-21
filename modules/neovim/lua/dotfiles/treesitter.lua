local M = {}

local has_treesitter, treesitter = pcall(require, "nvim-treesitter")
local has_treesitter_configs, treesitter_configs = pcall(require, "nvim-treesitter.configs")

function M.setup()
    if not has_treesitter_configs then
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
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@comment.outer",
                    ["ic"] = "@comment.inner",
                },
            },
        },
        ensure_installed = {
            "bash",
            "c",
            "cpp",
            "go",
            "html",
            "json",
            "lua",
            "python",
            "regex",
            "toml",
            "yaml"
        }
    }
end

function M.status()
    if not has_treesitter then
        return ""
    end
    local ok, statusline = pcall(treesitter.statusline,15)
    if not ok or not statusline then
        return ""
    end
    return statusline
end

return M
