local M = {}

local plugin = require("dotfiles.plugin")
local telescope = plugin.safe_require("telescope")
local builtin = plugin.safe_require("telescope.builtin")
local themes = plugin.safe_require("telescope.themes")


function M.setup()
    if not telescope then
        return
    end
    telescope.setup({
        defaults = {
            prompt_position = "top",
            sorting_strategy = "ascending",
            extensions = {
                fzy_native = {
                    override_generic_sorter = true,
                    override_file_sorter = true
                }
            }
        }
    })
    telescope.load_extension('fzy_native')

    local opts = { noremap = true, silent = true}
    vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>lua require('dotfiles.settings.telescope').find_files()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<Leader>ff", "<cmd>lua require('dotfiles.settings.telescope').find_files()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<Leader>fb", "<cmd>lua require('dotfiles.settings.telescope').find_buffers()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<Leader>ft", "<cmd>lua require('dotfiles.settings.telescope').tags()<CR>", opts)
    vim.api.nvim_set_keymap("n", "<Leader>fg", "<cmd>lua require('dotfiles.settings.telescope').live_grep()<CR>", opts)
end

function M.find_files()
    local opts = {
        shorten_path = false,
    }
    local ok = pcall(builtin.git_files, opts)
    if not ok then
        builtin.find_files(opts)
    end
end

function M.tags()
    builtin.tags()
end

function M.live_grep()
    builtin.live_grep()
end

function M.find_buffers()
    builtin.buffers()
end

function M.lsp_code_actions()
    if not builtin then
        return vim.lsp.buf_code_action()
    end
    local opts = themes.get_dropdown {
        winblend = 10,
        border = true,
        previewer = false,
        shorten_path = false,
    }
    return builtin.lsp_code_actions(opts)
end

return M
