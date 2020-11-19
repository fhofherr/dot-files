local M = {}

local has_treesitter, treesitter = pcall(require, "nvim-treesitter")
local has_treesitter_configs, treesitter_configs = pcall(require, "nvim-treesitter.configs")

function M.setup()
    if not has_treesitter_configs then
        return
    end

    treesitter_configs.setup {
        highlight = { enable = false },
        incremental_selection = { enable = true },
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
                disable = { "go" }, -- Gopher.vim defines textobjects for us
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@comment.outer", -- Same as defined by gopher.vim for go
                    ["ic"] = "@comment.inner", -- Same as defined by gopher.vim for go
                },
            },
        },
        ensure_installed = {
            "bash",
            "c",
            "go",
            "html",
            "json",
            "lua",
            "markdown",
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
    local statusline = treesitter.statusline(15)
    if not statusline then
        return ""
    end
    return statusline
end

return M
