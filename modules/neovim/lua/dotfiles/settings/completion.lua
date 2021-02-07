local M = {}

local plugin = require("dotfiles.plugin")
local completion = plugin.safe_require("completion")

local chain_complete_list = {
    default = {
        default = {
            {complete_items = {"snippet", "path"}},
            {mode = "<c-p>"},
            {mode = "<c-n>"}
        },
        comment = {},
    },
    go = {
        default = {
            {complete_items = {"lsp", "ts"}},
            {mode = "<c-p>"},
            {mode = "<c-n>"}
        }
    },
    python = {
        default = {
            {complete_items = {"lsp", "ts"}},
            {mode = "<c-p>"},
            {mode = "<c-n>"}
        }
    },
    lua = {
        default = {
            {complete_items = {"ts"}},
            {mode = "<c-p>"},
            {mode = "<c-n>"}
        }
    }
}

function M.setup()
    if not completion then
        return
    end

    vim.g.completion_auto_change_source = 1
    vim.g.completion_chain_complete_list = chain_complete_list
    vim.g.completion_enable_auto_popup = 1
    vim.g.completion_enable_auto_signature = 1
    vim.g.completion_enable_snippet = "UltiSnips"
    vim.g.completion_timer_cycle = 100

    local opts = { noremap=true, silent=true }
    vim.api.nvim_set_keymap("i", "<tab>", "<cmd>lua require('completion').smart_tab()<CR>", opts)
    vim.api.nvim_set_keymap("i", "<s-tab>", "<cmd>lua require('completion').smart_s_tab()<CR>", opts)

    vim.api.nvim_command([[
    autocmd BufEnter * lua require("completion").on_attach()
    ]])
end

return M
