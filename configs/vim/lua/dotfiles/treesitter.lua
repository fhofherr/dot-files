local M = {}

local has_treesitter, treesitter = pcall(require, "nvim-treesitter")
local has_treesitter_configs, treesitter_configs = pcall(require, "nvim-treesitter/configs")

function M.setup()
    if not has_treesitter_configs then
        return
    end

    treesitter_configs.setup {
        highlight = {
            enable = true
        },
        ensure_installed = {
            "bash",
            "c",
            "go",
            "json",
            "lua",
            "python",
            "toml"
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
