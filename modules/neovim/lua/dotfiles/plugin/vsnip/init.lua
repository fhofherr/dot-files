local M = {}

local vimcompat = require("dotfiles.vimcompat")

M.go = require("dotfiles.plugin.vsnip.go")

function M.config()
    vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
    vim.g.vsnip_filetypes = {
        ["markdown.pandoc"] = {"markdown"}
    }

    local opts = { noremap = false, silent = true, expr = true}
    vim.api.nvim_set_keymap("i", "<C-j>", "v:lua.dotfiles.plugin.vsnip.jump('<C-j>')", opts)
    vim.api.nvim_set_keymap("s", "<C-j>", "v:lua.dotfiles.plugin.vsnip.jump('<C-j>')", opts)
    vim.api.nvim_set_keymap("i", "<C-k>", "v:lua.dotfiles.plugin.vsnip.jump_back('<C-k>')", opts)
    vim.api.nvim_set_keymap("s", "<C-k>", "v:lua.dotfiles.plugin.vsnip.jump_back('<C-k>')", opts)

    vimcompat.add_to_globals("dotfiles.plugin.vsnip", M)
end

function M.jump(key)
    if vim.fn["vsnip#jumpable"](1) == 1 then
        return vimcompat.termesc("<Plug>(vsnip-jump-next)")
    end
    return vimcompat.termesc(key)
end

-- function M.expand_or_jump(key)
--     if vim.fn["vsnip#expandable"]() == 1 then
--         return vimcompat.termesc("<Plug>(vsnip-expand)")
--     end
--     if vim.fn["vsnip#jumpable"](1) == 1 then
--         return vimcompat.termesc("<Plug>(vsnip-jump-next)")
--     end
--     return vimcompat.termesc(key)
-- end

function M.jump_back(key)
    if vim.fn["vsnip#jumpable"](1) == 1 then
        return vimcompat.termesc("<Plug>(vsnip-jump-prev)")
    end
    return vimcompat.termesc(key)
end

return M
