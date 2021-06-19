local M = {}

local treesitter = require("nvim-treesitter")
local treesitter_configs = require("nvim-treesitter.configs")
local spellsitter = require("spellsitter")

function M.config()
    if spellsitter then
        spellsitter.setup()
    end

    treesitter_configs.setup {
        highlight = { enable = spellsitter ~= nil },
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
            enable = false,
            disable = {
                "go",  -- Gopls/goimports does that for us.
                "python", -- Does not really work as desired.
            },
        },
        refactor = {
            highlight_definitions = { enable = true },
            smart_rename = {
                enable = true,
                disable = { "go", "python" }, -- We use the language server for that
                keymaps = {
                    smart_rename = "<leader>rn"
                },
            },
        },
        textobjects = {
            lsp_interop = {
                enable = false,
                peek_definition_code = {
                    ["<leader>df"] = "@function.outer",
                    ["<leader>dF"] = "@class.outer",
                },
            },
            move = {
                enable = true,
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
            select = {
                enable = true,
                keymaps = {
                    ["ab"] = "@block.outer",
                    ["ib"] = "@block.inner",
                    ["ac"] = "@comment.outer",
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
