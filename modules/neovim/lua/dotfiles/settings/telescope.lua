local M = {}

local plugin = require("dotfiles.plugin")
local telescope = plugin.safe_require("telescope")
local telescope_builtin = plugin.safe_require("telescope.builtin")

function M.setup()
    if not telescope then
        return
    end
    telescope.setup({})

    local opts = { noremap = true, silent = true}
    vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>lua require('dotfiles.settings.telescope').find_files()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<Leader>ff", "<cmd>lua require('dotfiles.settings.telescope').find_files()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<Leader>ft", "<cmd>lua require('dotfiles.settings.telescope').tags()<CR>", opts)
end

function M.find_files()
    telescope_builtin.find_files()
end

function M.tags()
    telescope_builtin.tags()
end

function M.buf_code_action()
    if not telescope_builtin then
        return vim.lsp.buf_code_action()
    end
    return telescope_builtin.lsp_code_actions()
end

return M
