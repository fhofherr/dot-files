local M = {}

local plugin = require("dotfiles.plugin")

function M.setup()
    if not plugin.exists("vim-vsnip") then
        return
    end

    vim.g.vsnip_snippet_dir = vim.env.VIMHOME .. "/snippets"
    vim.g.vsnip_filetypes = {
        ["markdown.pandoc"] = {"markdown"}
    }

    local opts = { noremap = false, silent = true, expr = true}
    vim.api.nvim_set_keymap("i", "<C-j>", "vsnip#expandable()?'<Plug>(vsnip-expand)':'<C-j>'", opts)
    vim.api.nvim_set_keymap("s", "<C-j>", "vsnip#expandable()?'<Plug>(vsnip-expand)':'<C-j>'", opts)

    -- Define namespace for vsnip snippet modules.
    _G.dotfiles.settings.vsnip = {
        go = require("dotfiles.settings.vsnip.go"),
    }
end

return M
