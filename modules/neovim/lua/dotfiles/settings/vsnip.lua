local M = {}

local plugin = require("dotfiles.plugin")
local vimcompat = require("dotfiles.vimcompat")

M.go = require("dotfiles.settings.vsnip.go")

function M.setup()
    if not plugin.exists("vim-vsnip") then
        return
    end

    vim.g.vsnip_snippet_dir = vim.env.VIMHOME .. "/snippets"
    vim.g.vsnip_filetypes = {
        ["markdown.pandoc"] = {"markdown"}
    }

    local opts = { noremap = false, silent = true, expr = true}
    vim.api.nvim_set_keymap("i", "<C-j>", "v:lua.dotfiles.settings.vsnip.expand_or_jump('<C-j>')", opts)
    vim.api.nvim_set_keymap("s", "<C-j>", "v:lua.dotfiles.settings.vsnip.expand_or_jump('<C-j>')", opts)
    vim.api.nvim_set_keymap("i", "<C-k>", "v:lua.dotfiles.settings.vsnip.jump_back('<C-k>')", opts)
    vim.api.nvim_set_keymap("s", "<C-k>", "v:lua.dotfiles.settings.vsnip.jump_back('<C-k>')", opts)

    -- Define namespace for vsnip snippet modules.
    _G.dotfiles.settings.vsnip = M
end

function M.expand_or_jump(key)
    if vim.fn["vsnip#expandable"]() == 1 then
        return vimcompat.termesc("<Plug>(vsnip-expand)")
    end
    if vim.fn["vsnip#jumpable"](1) == 1 then
        return vimcompat.termesc("<Plug>(vsnip-jump-next)")
    end
    return vimcompat.termesc(key)
end

function M.jump_back(key)
    if vim.fn["vsnip#jumpable"](1) == 1 then
        return vimcompat.termesc("<Plug>(vsnip-jump-prev)")
    end
    return vimcompat.termesc(key)
end

return M
